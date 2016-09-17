# vue-textarea

a autoresizing textarea.

### [Demo](https://vue-comps.github.io/vue-textarea)

# Install

```sh
npm install --save-dev vue-textarea
```
or include `build/bundle.js`.

## Usage
```coffee
# in your component
components:
  "vc-textarea": require("vue-textarea")
# or, when using bundle.js
components:
  "vc-textarea": window.vueComps.textarea
```
```html
<vc-textarea>Content
  <span slot="placeholder">A placeholder</span>
</vc-textarea>
```
see [`dev/`](dev/) for examples.

#### Props
Name | type | default | description
---:| --- | ---| ---
value | String | textContent of slot | (two-way) content of the textarea
taclass | VueClass | [] | class of the textarea
style | VueStyle | [] | style of the wrapper div
autofocus | Boolean | false | autofocus
disabled | Boolean | false | disabled
readonly | Boolean | false | readonly
no-extra-line | Boolean | false | doesn't add the extra empty line on resize
size | Object | {height:`offsetHeight`,width:`offsetWidth`} | size of the closed textarea
max-size | Object | {height:`Number.MAX_VALUE`,width:`this.size.width`}  | size of the opened textarea
hover-size | Object | {height:`this.size.height`,width:`this.size.width`} | size of the closed textarea on hover
is-opened	| Boolean	| false | (two-way) set to open / close (will open on focus and close on blur)
transition-in | Function | no animation | animation for increasing size. Argument: {el,style,cb}
transition-out | Function | no animation | animation for reducing size. Argument: {el,style,cb}


#### Events
`focus`, `blur`, `keyup` will pass-through

Name |  description
---:| ---
before-enter | will be called before open animation
after-enter |  will be called when opened
before-leave |  will be called before close animation
after-leave |  will be called when closed
input | will be emitted when value changed

## Changelog

- 1.0.0  
events are renamed after vue transitions  
added unit tests  
bugfixes  

# Development
Clone repository.
```sh
npm install
npm run dev
```
Browse to `http://localhost:8080/`.

## License
Copyright (c) 2016 Paul Pflugradt
Licensed under the MIT license.
