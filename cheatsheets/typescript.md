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
```

### React Styled

```typescript
const Title = styled.Text<{isEditable: boolean}>`
  padding-bottom: ${({isEditable}) => (isEditable ? 14 : 0)}px;
`;
```
