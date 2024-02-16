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

        if (event.data.myInfo.Name) {
            $('#mojezajebaneimie').html(event.data.myInfo.Name);
        }

        if (event.data.myInfo.Job) {
            $('#mojzajebanyjob').html(event.data.myInfo.Job);
        }

        if (event.data.ServerName) {
            $('#mojpieknyservername').html(event.data.ServerName);
        }

        function updateCounter(counterType, counterElement) {
            if (event.data.cache.counter && event.data.cache.counter[counterType]) {
                $(counterElement).html(event.data.cache.counter[counterType]);
            } else {
                $(counterElement).html(0);
            }
        }


        updateCounter('police', '#slodkielspdcounbter');
        updateCounter('ambulance', '#slodkieambulancecounter');
        updateCounter('mecano', '#slodkiemechanikicounter');
        updateCounter('mechanik', '#slodkiemechanikicounter');
        updateCounter('mechanic', '#slodkiemechanikicounter');
        updateCounter('players', '#slodkiegraczecounter');
        updateCounter('admins', '#slodkieadminycounter');
    }
});
