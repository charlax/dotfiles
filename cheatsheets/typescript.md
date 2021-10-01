<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## Table of Contents

- [Typescript cheatsheet](#typescript-cheatsheet)
  - [Reference](#reference)
  - [Typings](#typings)
    - [Events](#events)
    - [Reduce](#reduce)
  - [React](#react)
    - [React Styled](#react-styled)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Typescript cheatsheet

## Reference

- https://github.com/typescript-cheatsheets/react-typescript-cheatsheet
- https://github.com/piotrwitek/react-redux-typescript-guide
- https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/react

## Typings

### Events

```typescript
React.ChangeEvent<HTMLInputElement>
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
// Extend HTML props component
interface Props extends React.HTMLProps<HTMLInputElement> {
  isActive: boolean;
}

interface Props {
  children: React.ReactNode
}
```

### React Styled

```typescript
const Title = styled.Text<{isEditable: boolean}>`
  padding-bottom: ${({isEditable}) => (isEditable ? 14 : 0)}px;
`;
```
