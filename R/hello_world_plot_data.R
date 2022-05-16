# hello world data

H <- function(xstart,
              ystart,
              height = 0.9,
              width = 0.1) {
  bind_rows(
    tibble(
      x = xstart,
      y = seq(ystart, ystart + height, length.out = 1000)
    ),
    
    # 2 vert
    tibble(
      x = xstart + width,
      y = seq(ystart, ystart + height, length.out = 1000)
    ),
    tibble(
      x = seq(xstart, xstart + width, length.out = 1000),
      y = ystart + (0.4*height)
    )
  )
}

E <- function(xstart,
              ystart,
              height = 0.8,
              width = 0.07) {
  bind_rows(
    # 1 vert
    tibble(
      x = xstart,
      y = seq(ystart, ystart + height, length.out = 1000),
    ),
    # 3 horiz
    tibble(
      x = seq(xstart, xstart + width, length.out = 1000),
      y = ystart + height,
    ),
    tibble(
      x = seq(xstart, xstart + 0.8 * width, length.out = 1000),
      y = ystart + (.4 * height),
    ),
    tibble(
      x = seq(xstart, xstart + width, length.out = 1000),
      y = ystart,
    )
  )
}

L <- function(xstart,
              ystart,
              width = 0.09,
              height = 0.8) {
  bind_rows(tibble(
    x = xstart,
    y = seq(ystart, ystart + height, length.out = 1000)
  ), # vert
  tibble(
    x = seq(xstart, xstart + width, length.out = 1000),
    y = ystart,
  ))
}

O <- function(xcenter,
              ycenter,
              radius,
              xstretch,
              ystretch) {
  tibble(r = radius,
         t = seq(0, 2 * pi, length.out = 1000)) |>
    transmute(x = xcenter + r * cos(t) * xstretch,
              y = ycenter + r * sin(t) * ystretch,
    )
}

W <- function(xstart, ystart, height, width) {
  bind_rows(
    # 3 vertical bars on a base
    tibble(
      x = xstart,
      y = seq(ystart, ystart + height, length.out = 1000),
    ),
    tibble(
      x = xstart + width/2,
      y = seq(ystart , ystart + height, length.out = 1000),
    ),
    tibble(
      x = xstart + width,
      y = seq(ystart, ystart + height, length.out = 1000),
    ),
    tibble(
      x = seq(xstart, xstart + width, length.out = 1000),
      y = ystart,
      ) 
  )
}

D <- function(xcenter, ycenter, xstretch = 0.2, ystretch = 1, radius = 1) {
  
  tibble(r = radius, t = c(seq(-pi/2, pi/2,length.out = 1000))) |>
    transmute(x = xcenter + r * cos(t) * xstretch,
              y = ycenter + r * sin(t) * ystretch,
    ) |> 
    bind_rows(
      tibble(x = xcenter,
             y = seq(
               ycenter - radius * ystretch, 
               ycenter + radius * ystretch, 
               length.out = 1000)
             )
    )
}

R <- function(xstart, ystart, width, height, slope){
  tibble(
    x = xstart,
    y = seq(ystart, ystart  + height / 2, length.out = 1000),
  ) |> 
    bind_rows(
      tibble(
        x = seq(xstart, xstart + width, length.out = 1000),
        y = slope*(x - xstart) + ystart + height/2
      )
    ) |> 
    bind_rows(
      D(xcenter = xstart,
        ycenter = ystart + height/2 + height/5, xstretch = 0.1, ystretch = 0.4, radius = 0.5)
    )
}
  
exclam <- function(xstart, ystart, height = 0.8, width = 0.1){
  bind_rows(
    tibble(
      x = xstart,
      y = seq(ystart, ystart + (height*0.1), length.out = 100)
    ),
    tibble(
      x = xstart + width,
      y = seq(ystart, ystart + (height*0.1), length.out = 100)
    )
  ) |> 
    bind_rows(
      tibble(
        x = seq(xstart, xstart + width, length.out = 100),
        y = ystart + (height*0.1),
      ),
      tibble(
        x = seq(xstart, xstart + width, length.out = 100),
        y = ystart
      )
    ) |> 
    bind_rows(
      tibble(
        x = xstart,
        y = seq(ystart + (height*0.2), ystart + (height), length.out = 100)
      ),
      tibble(
        x = xstart + width,
        y = seq(ystart + (height*0.2), ystart + height, length.out = 100)
      )
    ) |>
    bind_rows(
      tibble(
        x = seq(xstart, xstart + width, length.out = 100),
        y = ystart + (height),
      ),
      tibble(
        x = seq(xstart, xstart + width, length.out = 100),
        y = ystart + (height * 0.2)
      )
    )
}

bind_rows(
  H(xstart = 0.21, ystart = 0.1, width = 0.06, height = 0.8),
  E(xstart = .3, ystart = 0.1, height = 0.8, width = 0.05),
  L(
    xstart = 0.38,
    ystart = 0.1,
    height = 0.8,
    width = 0.04
  ),
  L(
    xstart = 0.44,
    ystart = 0.1,
    height = 0.8,
    width = 0.04
  ),
  O(
    xcenter = 0.52,
    ycenter = 0.5,
    radius = 0.1,
    ystretch = 4,
    xstretch = 0.3
  ),
  W(
    xstart = 0.27,
    ystart = -0.9,
    width = 0.07,
    height = 0.8
  ),
  O(
    xcenter = 0.39,
    ycenter = -0.5,
    radius = 0.1,
    ystretch = 4,
    xstretch = 0.3
  ) ,
  R(xstart = 0.45, ystart = -0.9, width = 0.05, height = 0.9, slope = -8.9),
  L(
    xstart = 0.52,
    ystart = -0.9,
    width = 0.04,
    height = 0.8
  ),
  D(xcenter = 0.58, ycenter = -0.5, xstretch = 0.1, ystretch = 0.8, radius = 0.5),
  exclam(xstart = 0.65, ystart = -0.9, width = 0.01)
) |>
  ggplot(aes(x, y)) + geom_point() 



