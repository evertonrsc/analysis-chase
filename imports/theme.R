# ggplot2 publication theme
theme_pub <- function(base_size = 11){
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_blank(),
      # plot.title = element_text(face = "bold"),
      plot.title = element_blank(),
      axis.title.x = element_text(margin = margin(t = 6)),
      axis.title.y = element_text(margin = margin(r = 6)),
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )
}