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
| Name | type | default | description |
| ---:| --- | ---| --- |
| value | String | `textContent` | (two-way) content of the textarea |
| class | String | "" | class of the textarea |
| size | Object | {height:`offsetHeight`,width:`offsetWidth`} | size of the closed textarea |
| max-size | Number | {height:`Number.MAX_VALUE`,width:`this.size.width`}  | size of the opened textarea |
| hover-size | Number | {height:`this.size.height`,width:`this.size.width`} | size of the closed textarea on hover |
| is-opened	| Boolean	| false | (two-way) set to open / close (will open on focus and close on blur)|
| transition-in | function | no animation | animation for increasing size. Argument: {el,style,cb} |
| transition-out | function | no animation | animation for reducing size. Argument: {el,style,cb} |


#### Events
| Name |  description |
| ---:| --- |
| before-open | will be called before open animation |
| opened |  will be called when opened |
| before-close |  will be called before close animation |
| closed |  will be called when closed |


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
