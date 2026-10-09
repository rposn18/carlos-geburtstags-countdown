library(shiny)

ui <- fluidPage(
  
  tags$head(
    tags$meta(
      name = "viewport",
      content = "width=device-width, initial-scale=1"
    ),
    
    
    tags$style(HTML("
  html, body {
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
  }

  body {
    background: #f4f6f8;
    font-family: Arial, Helvetica, sans-serif;
    color: #26384a;
  }

  .container-fluid {
    padding: 0;
    height: 100%;
  }

  .boarding-card {
    width: 100%;
    max-width: 900px;
    height: 100vh;
    height: 100dvh;
    margin: 0 auto;
    background: white;
    overflow: hidden;
    display: flex;
    flex-direction: column;
  }

  .header {
    flex: 0 0 auto;
    text-align: center;
    padding: 10px 16px;
    border-bottom: 1px solid #e8edf2;
  }

  .logo {
    display: block;
    max-width: 250px;
    max-height: 15vh;
    width: auto;
    height: auto;
    object-fit: contain;
    margin: 0 auto 6px;
  }

  .header h1 {
    font-size: clamp(20px, 3vh, 28px);
    margin: 0;
    color: #bd1830;
  }

  .header p {
    font-size: 11px;
    letter-spacing: 3px;
    margin: 6px 0 0;
    color: #075b96;
    font-weight: bold;
  }

  .content {
    flex: 1 1 auto;
    min-height: 0;
    padding: 10px 20px;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    overflow: hidden;
  }

  .welcome {
    font-size: clamp(18px, 3vh, 24px);
    font-weight: bold;
    margin: 4px 0;
  }

  .message {
    font-size: clamp(13px, 2vh, 17px);
    line-height: 1.4;
    margin: 4px 0;
  }

  /* Schwarz-weiße FRA-Flughafen-Anzeigetafel */
  .countdown-panel {
        background: #f5f8fb;
        border-top: 2px dashed #b9c9d8;
        border-bottom: 2px dashed #b9c9d8;
        padding: 25px 12px;
        margin: 25px 0;
      }

      .countdown-title {
        color: #bd1830;
        font-size: 15px;
        font-weight: bold;
        letter-spacing: 2px;
        text-transform: uppercase;
        margin-bottom: 22px;
      }

      .countdown {
        display: flex;
        justify-content: center;
        gap: 10px;
      }

      .countdown-unit {
        flex: 1;
        min-width: 0;
        max-width: 110px;
        background: white;
        border: 1px solid #dce5ed;
        border-radius: 12px;
        padding: 18px 4px 13px;
        box-shadow: 0 3px 8px rgba(0,0,0,0.04);
      }

      .countdown-number {
        display: block;
        font-size: 38px;
        line-height: 1.1;
        font-weight: bold;
        color: #075b96;
        font-variant-numeric: tabular-nums;
      }

      .countdown-label {
        display: block;
        font-size: 11px;
        margin-top: 9px;
        color: #687b8d;
        text-transform: uppercase;
        letter-spacing: 1px;
      }
  
  .closing {
    font-size: clamp(13px, 2vh, 17px);
    line-height: 1.4;
    margin: 6px 0;
  }

  .airport-name {
    display: block;
    color: #bd1830;
    font-size: 18px;
    font-weight: bold;
    margin-top: 4px;
  }

  .pdf-link {
    display: inline-block;
    background: #075b96;
    color: white;
    padding: 10px 16px;
    border-radius: 8px;
    text-decoration: none;
    font-weight: bold;
  }

  .pdf-link:hover {
    background: #064875;
    color: white;
    text-decoration: none;
  }

  .footer {
    flex: 0 0 6px;
    background: linear-gradient(
      90deg,
      #075b96 0%,
      #075b96 50%,
      #bd1830 50%,
      #bd1830 100%
    );
  }

  .finished {
    color: white;
    font-size: clamp(18px, 3vh, 25px);
    font-weight: bold;
    line-height: 1.4;
  }

  @media (max-height: 650px) {
    .header {
      padding: 5px 10px;
    }

    .logo {
      max-height: 10vh;
      max-width: 180px;
      margin-bottom: 3px;
    }

    .content {
      padding: 5px 12px;
    }

    .countdown-panel {
      padding: 8px;
      margin: 4px 0;
    }

    .countdown-title {
      margin-bottom: 8px;
    }

    .countdown-unit {
      padding: 7px 2px;
    }

    .closing {
      margin: 3px 0;
    }
  }
")),
    
    # Countdown: lokale Zeit des jeweiligen Browsers
    tags$script(HTML("
      (function () {
        var timer = null;

        function updateCountdown() {
          var target = new Date(2026, 9, 24, 15, 0, 0).getTime();
          var now = new Date().getTime();
          var distance = target - now;

          var days = document.getElementById('cd-days');
          var hours = document.getElementById('cd-hours');
          var minutes = document.getElementById('cd-minutes');
          var seconds = document.getElementById('cd-seconds');
          var panel = document.getElementById('countdown-values');
          var finished = document.getElementById('countdown-finished');

          if (!days || !hours || !minutes || !seconds) {
            return;
          }

          if (distance <= 0) {
            days.textContent = '00';
            hours.textContent = '00';
            minutes.textContent = '00';
            seconds.textContent = '00';

            if (panel) panel.style.display = 'none';
            if (finished) finished.style.display = 'block';

            if (timer) {
              clearInterval(timer);
              timer = null;
            }

            return;
          }

          var d = Math.floor(distance / (1000 * 60 * 60 * 24));
          var h = Math.floor((distance % (1000 * 60 * 60 * 24)) /
                             (1000 * 60 * 60));
          var m = Math.floor((distance % (1000 * 60 * 60)) /
                             (1000 * 60));
          var s = Math.floor((distance % (1000 * 60)) / 1000);

          days.textContent = String(d).padStart(2, '0');
          hours.textContent = String(h).padStart(2, '0');
          minutes.textContent = String(m).padStart(2, '0');
          seconds.textContent = String(s).padStart(2, '0');

          if (panel) panel.style.display = 'flex';
          if (finished) finished.style.display = 'none';
        }

        function startCountdown() {
          if (timer) clearInterval(timer);
          updateCountdown();
          timer = setInterval(updateCountdown, 1000);
        }

        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', startCountdown);
        } else {
          startCountdown();
        }
      })();
    "))
  ),
  
  div(
    class = "boarding-card",
    
    div(
      class = "header",
      
      tags$img(
        src = "/img/knuffingen_airport2.jpg",
        class = "logo",
        alt = "Knuffingen Airport"
      ),
      
      h1("Carlos' Geburtstagsflug"),
      
      p("SONDERFLUG ZUM GEBURTSTAG")
    ),
    
    div(
      class = "content",
      
      div(
        class = "welcome",
        "Herzlich willkommen zum Geburtstag von Carlos!"
      ),
      
      div(
        class = "message",
        "Die Vorbereitungen laufen und der Abflug rückt näher. ",
        "Verfolgt hier den Countdown bis zum Check-in!"
      ),
      
      div(
        class = "countdown-panel",
        
        div(
          class = "countdown-title",
          "Countdown bis zum Check-In"
        ),
        
        div(
          id = "countdown-values",
          class = "countdown",
          
          div(
            class = "countdown-unit",
            span(id = "cd-days", class = "countdown-number", "00"),
            span(class = "countdown-label", "Tage")
          ),
          
          div(
            class = "countdown-unit",
            span(id = "cd-hours", class = "countdown-number", "00"),
            span(class = "countdown-label", "Stunden")
          ),
          
          div(
            class = "countdown-unit",
            span(id = "cd-minutes", class = "countdown-number", "00"),
            span(class = "countdown-label", "Minuten")
          ),
          
          div(
            class = "countdown-unit",
            span(id = "cd-seconds", class = "countdown-number", "00"),
            span(class = "countdown-label", "Sekunden")
          )
        ),
        
        div(
          id = "countdown-finished",
          class = "finished",
          style = "display:none;",
          "Jetzt ist Check-in! ",
          tags$br(),
          "Carlos' Geburtstagsflug kann beginnen! ✈"
        )
      ),
      
      div(
        class = "closing",
        
        "Bitte bringt deine Boardingkarte zur Geburtstagsfeier mit!",
        
        tags$br(),
        
        "Wir freuen uns auf dich!",
        
        span(
          class = "airport-name",
          "Knuffingen Airport"
        ),
        
        # tags$div(
        #   style = "margin: 25px 0 0;",
        #   
        #   tags$a(
        #     href = "/img/boardingkarte.pdf",
        #     target = "_blank",
        #     class = "pdf-link",
        #     "✈ Boardingkarte als PDF öffnen"
        #   )
        # )
      )
    ),
    
    div(class = "footer")
  )
)

server <- function(input, output, session) {
}

shinyApp(
  ui = ui,
  server = server,
  options = list(
    host = "0.0.0.0",
    port = 8001
  )
)
