<template lang="pug">
.container
  a(href="https://github.com/vue-comps/vue-textarea/blob/master/dev/basic.vue") source
  p all have a max-height of 200
  vc-textarea(v-bind:size="{height:50}",v-bind:max-size="{height:200,width:200}")
    span(slot="placeholder") a placeholder
  p pre-filled with `max-width=200`:
  vc-textarea(
    v-bind:size="{height:50}",
    v-bind:max-size="{height:200,width:200}",
    ) Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
    span(slot="placeholder") a placeholder
  p pre-filled without `max-width`
  vc-textarea(v-bind:size="{height:50}",v-bind:max-size="{height:200}") Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
    span(slot="placeholder") a placeholder
  p pre-filled with hover-size for a preview
  vc-textarea(v-bind:size="{height:50}",v-bind:max-size="{height:200,width:200}",v-bind:hover-size="{height:150,width:180}") Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
    span(slot="placeholder") a placeholder
</template>

<script lang="coffee">
module.exports =
  components:
    "vc-textarea" : require "../src/textarea.vue"

</script>
