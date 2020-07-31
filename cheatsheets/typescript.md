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
