{ ... }:
''
  output "eDP-1" {
      mode "3200x2000@165.0"
      scale 2.0
      position x=503 y=0
      focus-at-startup
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
  }
  output "DP-3" {
      mode "2560x1600@60.0"
      scale 1.6
      position x=2103 y=1000
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
  }
  output "DP-4" {
      mode "2560x1600@60.0"
      scale 1.6
      position x=2103 y=0
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
  }
  output "DP-5" {
      mode "2560x1600@60.0"
      scale 1.6
      position x=2103 y=0
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
  }
  output "Samsung Electric Company S24E450 H4LN700023" {
      mode "1920x1080@60.0"
      scale 1.2
      position x=3703 y=100
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
      layout {
          preset-column-widths {
              proportion 0.2
              proportion 0.5
              proportion 0.685
              proportion 1.0
          }
          default-column-width { proportion 0.5; }
      }
  }
  output "Samsung Electric Company U32J59x HNMR102088" {
      mode "3840x2160@30.0"
      scale 2.0
      position x=2103 y=0
      hot-corners {
        off
        // top-left
        // top-right
        // bottom-left
        // bottom-right
      }
  }
''
