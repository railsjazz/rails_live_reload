var RailsLiveReload = {
  start: ({ files, time, url }) => {
    (function () {
      let retries_count = 0;
      function poll() {
        const formData = new FormData();
        formData.append("dt", time);
        formData.append("files", JSON.stringify(files));

        fetch(url, {
          method: "post",
          headers: { Accept: "application/json" },
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            retries_count = 0;
            if (data["command"] === "RELOAD") {
              window.location.reload();
            } else {
              poll();
            }
          })
          .catch(() => {
            retries_count++;

            if (retries_count < 10) {
              setTimeout(poll, 5000);
            }
          });
      }
      poll();
    })();
  },
};
