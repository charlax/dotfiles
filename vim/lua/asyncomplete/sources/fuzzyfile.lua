-- Fuzzy file completion source for asyncomplete (Lua implementation)
-- Optimized for better performance compared to VimScript version

local M = {}

-- Calculate fuzzy match score
-- Returns -1 if no match, otherwise returns a score (lower is better)
local function fuzzy_match_score(str, pattern)
  if pattern == "" then
    return 0
  end

  local str_lower = str:lower()
  local pattern_lower = pattern:lower()

  local score = 0
  local str_idx = 1
  local pattern_idx = 1
  local last_match_idx = -1

  while pattern_idx <= #pattern_lower do
    local pattern_char = pattern_lower:sub(pattern_idx, pattern_idx)
    local found = false

    while str_idx <= #str_lower do
      if str_lower:sub(str_idx, str_idx) == pattern_char then
        -- Bonus for consecutive matches
        if last_match_idx >= 0 and str_idx == last_match_idx + 1 then
          score = score + 1
        else
          score = score + 5
        end

        -- Bonus for matching at word boundaries
        if str_idx == 1 or str:sub(str_idx - 1, str_idx - 1):match('[_%.%-%/]') then
          score = score - 2
        end

        last_match_idx = str_idx
        str_idx = str_idx + 1
        found = true
        break
      end
      str_idx = str_idx + 1
    end

    if not found then
      return -1
    end

    pattern_idx = pattern_idx + 1
  end

  return score
end

-- Format a file match
local function format_match(file, prefix, pattern)
  local basename = vim.fn.fnamemodify(file, ':t')
  local is_dir = vim.fn.isdirectory(file) == 1

  -- Calculate the word to insert
  local word
  if prefix == "" or prefix == "." then
    word = basename
  else
    word = prefix .. basename
  end

  -- Format abbreviation
  local abbr = basename
  if is_dir then
    abbr = abbr .. '/'
  end

  -- Calculate fuzzy match score
  local score = fuzzy_match_score(basename, pattern)

  return {
    word = word,
    abbr = abbr,
    menu = is_dir and '[dir]' or '[file]',
    dup = 1,
    icase = 1,
    user_data = {
      is_dir = is_dir,
      score = score
    }
  }
end

-- Sort comparison function
local function sort_matches(m1, m2)
  local d1 = m1.user_data.is_dir
  local d2 = m2.user_data.is_dir

  -- Directories first
  if d1 and not d2 then
    return true
  elseif not d1 and d2 then
    return false
  end

  -- Then by fuzzy match score
  local s1 = m1.user_data.score or 999
  local s2 = m2.user_data.score or 999

  if s1 ~= s2 then
    return s1 < s2
  end

  -- Finally alphabetically
  return m1.abbr < m2.abbr
end

-- Main completor function
function M.completor(ctx)
  local bufnr = ctx.bufnr
  local typed = ctx.typed
  local col = ctx.col

  -- Match file path patterns - check each pattern explicitly
  local kw = nil

  -- Try patterns in order: longer patterns first
  local patterns = {
    '%.%.%./[^%s]*',  -- ../../path
    '%.%./[^%s]*',    -- ../path
    '%./[^%s]*',      -- ./path
    '~[^%s]*',        -- ~/path
    '/[^%s]*'         -- /path
  }

  for _, pattern in ipairs(patterns) do
    kw = typed:match(pattern .. '$')
    if kw then
      break
    end
  end

  if not kw then
    return nil
  end

  local kwlen = #kw

  if kwlen < 1 then
    return nil
  end

  -- Determine the directory to search
  local dir = vim.fn.fnamemodify(kw, ':h')
  local partial = vim.fn.fnamemodify(kw, ':t')

  local search_dir, prefix

  -- Resolve directory path and preserve user's prefix
  if kw:match('^/') then
    -- Absolute path
    search_dir = (dir == '/') and '/' or dir
    prefix = (dir == '/') and '/' or (dir .. '/')
  elseif kw:match('^~') then
    -- Home directory
    local expanded = vim.fn.expand(dir)
    search_dir = expanded
    prefix = dir .. '/'
  elseif kw:match('^%.%.') then
    -- Parent directory (../ or ../../)
    local buf_dir = vim.fn.expand('#' .. bufnr .. ':p:h')
    search_dir = buf_dir .. '/' .. dir
    prefix = dir .. '/'
  elseif kw:match('^%.%/') then
    -- Explicit current directory (./)
    local buf_dir = vim.fn.expand('#' .. bufnr .. ':p:h')
    search_dir = (dir == '.') and buf_dir or (buf_dir .. '/' .. dir)
    prefix = (dir == '.') and './' or (dir .. '/')
  elseif dir == '.' or dir == '' then
    -- Implicit current directory (no prefix)
    local buf_dir = vim.fn.expand('#' .. bufnr .. ':p:h')
    search_dir = buf_dir
    prefix = ''
  else
    -- Relative path (subdirs/)
    local buf_dir = vim.fn.expand('#' .. bufnr .. ':p:h')
    search_dir = buf_dir .. '/' .. dir
    prefix = dir .. '/'
  end

  -- Normalize prefix
  if prefix:match('//$') then
    prefix = prefix:gsub('/+$', '/')
  end

  if prefix ~= '' and not prefix:match('/$') then
    prefix = prefix .. '/'
  end

  -- Get all files in directory (including hidden files)
  local glob_pattern = search_dir .. '/*'
  local files = vim.fn.glob(glob_pattern, 0, 1)

  -- Also get hidden files (starting with .)
  local hidden_pattern = search_dir .. '/.[^.]*'
  local hidden_files = vim.fn.glob(hidden_pattern, 0, 1)

  -- Combine files and hidden files (compatible with Vim Lua)
  for _, file in ipairs(hidden_files) do
    table.insert(files, file)
  end

  -- Filter and score matches
  local matches = {}
  for _, file in ipairs(files) do
    local basename = vim.fn.fnamemodify(file, ':t')
    local score = fuzzy_match_score(basename, partial)

    -- Only include if fuzzy match succeeds or no pattern
    if score >= 0 or partial == '' then
      local match = format_match(file, prefix, partial)
      table.insert(matches, match)
    end
  end

  -- Sort matches
  table.sort(matches, sort_matches)

  local startcol = col - kwlen

  return {
    startcol = startcol,
    matches = matches
  }
end

return M
