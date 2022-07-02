var RailsLiveReload = {
  start: ({ files, time, url, config: { polling_interval } }) => {
    const timer = setInterval(() => {
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
          if (data["command"] === "RELOAD") {
            clearInterval(timer);
            window.location.reload();
          }
        });
    }, polling_interval);
  },
};
