export default {
  mounted() {
    const textareaEl = this.el.querySelector("textarea")
    const counterEl = this.el.querySelector("#symbols-count")

    counterEl.innerHTML = textareaEl.value.length;

    textareaEl.addEventListener("input", e => {
      const currentLength = e.target.value.length;

      counterEl.innerHTML = currentLength;
    })
  },
};
