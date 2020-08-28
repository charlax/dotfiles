# Typescript cheatsheet

## Reference

* https://github.com/typescript-cheatsheets/react-typescript-cheatsheet
* https://github.com/piotrwitek/react-redux-typescript-guide

## React

```typescript
// Extend HTML props component
interface Props extends React.HTMLProps<HTMLInputElement> {
  isActive: boolean;
}
```

## React Styled

```typescript
const Title = styled.Text<{isEditable: boolean}>`
  padding-bottom: ${({isEditable}) => (isEditable ? 14 : 0)}px;
`;
```
