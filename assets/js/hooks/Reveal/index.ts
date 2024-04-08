import Reveal from "reveal.js";

export default {
  _deck: null,

  mounted() {
    // @ts-ignore
    this._deck = new Reveal(); 
    this._deck.initialize()
  },
  destroyed() {
    this._deck.destroy()
  }
};
