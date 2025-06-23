<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Typescript cheatsheet](#typescript-cheatsheet)
  - [Reference](#reference)
  - [Typings](#typings)
    - [Fetch](#fetch)
    - [Reduce](#reduce)
  - [React](#react)
    - [Events](#events)
    - [React Styled](#react-styled)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Typescript cheatsheet

## Reference

- https://github.com/typescript-cheatsheets/react-typescript-cheatsheet
- https://github.com/piotrwitek/react-redux-typescript-guide
- https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/react

- Ignore: `// @ts-ignore`

## Typings

### Fetch

```typescript
const response = await fetch("http://localhost/health")
const parsed = (await response.json() as {msg: string})
```

### Reduce

```typescript
const params = {}
const params2 = Object.entries(params)
  .filter(([key, value]) => !(value instanceof Array))
  .reduce<Record<string, string>>((acc, [key, value]) => {
    acc[key] = value.toString();
    return acc;
  }, {});
```

## React

```typescript
// React.FC has some benefits but is DISCOURAGED because:
// - it accepts children by default
// - it does not play well with generics
// See https://github.com/typescript-cheatsheets/react#function-components
const Component:React.FC<Props> = ({message}) => {
  return <p>{message}</p>
}

// Extend HTML props component
interface Props extends React.HTMLProps<HTMLInputElement> {
  isActive: boolean;
}

interface Props {
  children: React.ReactNode
}

// Context
interface StateContextInterface {
  isActive: boolean;
}
const StateContext = React.createContext<StateContextInterface | null>(null);
```

### Events

```typescript
// Property 'value' does not exist on type 'EventTarget'
const onChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setValue(e.target.value);
}
```


### React Styled

```typescript
const Title = styled.Text<{isEditable: boolean}>`
  padding-bottom: ${({isEditable}) => (isEditable ? 14 : 0)}px;
`;
```


See: https://www.typescriptlang.org/cheatsheets/
