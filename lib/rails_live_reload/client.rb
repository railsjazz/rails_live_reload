module RailsLiveReload
  class Client

    def Client.js_code
      %Q{
        <script>
          const files = #{CurrentRequest.current.data.to_a.to_json};
          setInterval(
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
                    window.location.reload()
                  }
                })
            }, 100
          )
        </script>
        }.html_safe
    end

  end
end