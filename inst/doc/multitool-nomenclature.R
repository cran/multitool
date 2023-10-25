## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----echo=FALSE, fig.width=5.75, fig.height=6---------------------------------
DiagrammeR::grViz("
digraph boxes_and_circles {

  # a 'graph' statement
  graph [overlap = true, fontsize = 10]

  # several 'node' statements
  node [shape = box,
        fill = gray,
        fontname = Helvetica]
  1 [label = 'base data']
  2 [label = 'add_*() functions']
  3 [label = 'expand_decisions()']
  4 [label = 'create_blueprint_graph()']
  5 [label = 'run_descriptives()']
  6 [label = 'show_code_*()']
  7 [label = 'run_multiverse()']
  8 [label = 'reveal(), reveal_model_*()']
  9 [label = 'condense()']
  10 [label = 'reveal_corrs(), reveal_reliabilities(), reveal_summary_stats()']
  11 [label = 'column_plot(), custom plotting/tables']
  12 [label = 'detect_*(), summarize_filter_ns()']

  # several 'edge' statements
  1->2 [label = '.df']
  2->3 [label = '.pipeline']
  2->4 [label = '.pipeline']
  2->5 [label = '.pipeline']
  3->6 [label = '.grid']
  3->7 [label = '.grid']
  7->8 [label = '.multi']
  8->9 [label = '.unpacked']
  5->10 [label = '.descriptives']
  10->9 [label = '.unpacked']
  9->11 [label = '.condensed']
  2->12 [label = '.pipeline']
}
")

