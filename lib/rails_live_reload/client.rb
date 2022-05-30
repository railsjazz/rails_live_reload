module RailsLiveReload
  class Client

    def Client.js_code
      %Q{
        <script>
          const files = #{CurrentRequest.current.data.to_a.to_json};
          const timer = setInterval(
            () => {
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
                  if(data['command'] === 'RELOAD') {
                    clearInterval(timer);
                    window.location.reload();
                  }
                })
            }, #{RailsLiveReload.timeout}
          )
        </script>
        }.html_safe
    end

  end
end