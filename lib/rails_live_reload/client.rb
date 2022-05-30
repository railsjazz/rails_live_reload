module RailsLiveReload
  class Client

    def Client.js_code
      <<~HTML.html_safe
        <script>
          (function() {
            const files = #{CurrentRequest.current.data.to_a.to_json};
            let retries_count = 0;
            function poll() {
              const formData = new FormData();
              formData.append('dt', #{Time.now.to_i})
              formData.append('files', JSON.stringify(files))

              fetch(
                "#{RailsLiveReload.url}", 
                {
                  method: "post",
                  headers: { 'Accept': 'application/json', },
                  body: formData
                }
              )
                .then(response => response.json())
                .then(data => {
                  retries_count = 0;
                  if(data['command'] === 'RELOAD') {
                    window.location.reload();
                  } else {
                    poll();
                  }
                }).catch(() => {
                  retries_count++;

                  if(retries_count < 10) {
                    setTimeout(poll, 5000)
                  }
                })
            }
            poll();
          })();
        </script>
      HTML
    end

  end
end