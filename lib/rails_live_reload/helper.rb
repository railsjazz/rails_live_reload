module RailsLiveReload
  module Helper

    def Helper.rails_live_reload
      %Q{
        <div id="rails_live_reload_dt" rails_live_reload_dt="#{Time.now.to_i}"></div>
        <script>
          const files = #{CurrentRequest.current.data.to_a.to_json};
          setInterval(
            () => {
              const rails_live_reload_dt = document.getElementById("rails_live_reload_dt")
              const dt = rails_live_reload_dt.getAttribute("rails_live_reload_dt")
              console.log(dt)

              const formData = new FormData();
              formData.append('dt', dt)
              formData.append('files', JSON.stringify(files))

              fetch(
                "/xxx", 
                {
                  method: "post",
                  headers: {
                    'Accept': 'application/json',
                  },
                  body: formData
                }
              )
                .then(response => response.json())
                .then(data => {
                  console.log(data)
                  if(data['command'] === 'RELOAD') {
                    window.location.reload()
                  }
                })
            }, 1000
          )
        </script>
        }.html_safe
    end

    def rails_live_reload
      Helper.rails_live_reload
    end

  end
end