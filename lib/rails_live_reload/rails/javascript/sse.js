var RailsLiveReload = {
  start: ({ files, time, url, config: { files_param } }) => {
    const evtSource = new EventSource(`${url}?dt=${time}&${files_param}`);
    evtSource.onmessage = function(e) {
      const data = JSON.parse(e.data);
    
      if(data['command'] === 'RELOAD') {
        window.location.reload();
      }
    }
  },
};
