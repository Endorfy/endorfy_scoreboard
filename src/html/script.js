window.addEventListener('message', function (event) {
    if (event.data.action === "show") {
        var zetkaElement = document.querySelector('.zetka2');

        if (event.data.state) {
            console.log('block');
            zetkaElement.style.display = 'block';
        } else {
            console.log('none');
            zetkaElement.style.display = 'none';
        }
    } else if (event.data.action === "update") {

        if (event.data.myInfo && event.data.myInfo.Name) {
            console.log(event.data.myInfo.Name)
            document.getElementById('mojezajebaneimie').innerHTML = event.data.myInfo.Name;
        }

        if (event.data.myInfo && event.data.myInfo.Job) {
            document.getElementById('mojzajebanyjob').innerHTML = event.data.myInfo.Job;
        }

        if (event.data.ServerName) {
            document.getElementById('mojpieknyservername').innerHTML = event.data.ServerName;
        }

        function updateCounter(counterType, counterElement) {
            if (event.data.cache && event.data.cache.counter && event.data.cache.counter[counterType]) {
                document.getElementById(counterElement).innerHTML = event.data.cache.counter[counterType];
            } else {
                document.getElementById(counterElement).innerHTML = 0;
            }
        }

        updateCounter('police', 'slodkielspdcounbter');
        updateCounter('ambulance', 'slodkieambulancecounter');
        updateCounter('mecano', 'slodkiemechanikicounter');
        updateCounter('mechanik', 'slodkiemechanikicounter');
        updateCounter('mechanic', 'slodkiemechanikicounter');
        updateCounter('players', 'slodkiegraczecounter');
        updateCounter('admins', 'slodkieadminycounter');
    }
});
