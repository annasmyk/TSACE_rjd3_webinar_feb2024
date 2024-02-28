################################################################################
#######                        Wrangling WS in V3                        #######
################################################################################

# Objectifs :
#   - instant reading (load_workspace --> ça c'est fait)
#   - creation + saving
#   - modification = vrai wrangling (add sa item, replace_sa_item...)
#   - update_path
#   - handling metadata (comments)
#   - handling several workspaces (transfer series, ...)

# Loading packages -------------------------------------------------------------

library("rjdemetra3")
library("rjd3providers")

source("./R/update_path.R")


# Initialising a project: update_path ------------------------------------------

jws_work <- .jws_open(file = "WS/ws_work.xml")

## Update_massively the path
txt_update_path(
    jws = jws_work,
    new_path = normalizePath("./data/IPI_nace4.csv"),
    idx_sap = 1L
)
spreadsheet_update_path(
    jws = jws_work,
    new_path = normalizePath("./data/IPI_nace4.xlsx"),
    idx_sap = 2L
)

save_workspace(
    jws = jws_work,
    file = "WS/new_ws_work.xml",
    replace = TRUE
)


# Workspace creation -----------------------------------------------------------

new_jws <- .jws_new()
new_jsap <- .jws_sap_new(jws = new_jws, name = "SAP-1")
new_jsap2 <- .jws_sap_new(jws = new_jws, name = "SAP-2")


# Workspace saving -------------------------------------------------------------

save_workspace(jws = new_jws, file = "./temp/new_ws_R.xml")


# Loading ----------------------------------------------------------------------

## Workspace loading -----------------------------------------------------------

# Get the Java object
jws_work <- .jws_open(file = "WS/new_ws_work.xml")

# Get the readable object
read_workspace(jws = jws_work, compute = TRUE)


## SA-Processing loading -------------------------------------------------------

# Get the Java object
jsap_work <- .jws_sap(jws = jws_work, idx = 1L)

# Get the readable object
read_sap(jsap = jsap_work)


## SA-Item loading -------------------------------------------------------------

# Get the Java object
jsai_work <- .jsap_sa(jsap_work, idx = 1)

# Get the readable object
.jsa_read(jsai_work)


# Workspace wrangling ----------------------------------------------------------

## add_sa_item() ---------------------------------------------------------------

# add a SA-Item created with R
sa_x13 <- rjd3x13::x13(rjd3toolkit::ABS[, 1])
sa_ts <- rjd3tramoseats::tramoseats(rjd3toolkit::ABS[, 2])

add_sa_item(jsap = new_jsap, name = "ABS_1", x = sa_x13)
add_sa_item(jsap = new_jsap, name = "ABS_2", x = sa_ts)


# add a raw series with a spec created in R
add_sa_item(
    jsap = new_jsap,
    name = "ABS_3",
    x = rjd3toolkit::ABS[, 3],
    spec = rjd3x13::x13_spec(name = "RSA5c")
)
add_sa_item(
    jsap = new_jsap,
    name = "ABS_4",
    x = rjd3toolkit::ABS[, 4],
    spec = rjd3tramoseats::tramoseats_spec(name = "rsafull")
)


# add a SA_Item from another workspace
add_sa_item(jsap = new_jsap, name = "ABS_4", x = jsai_work)


## remove_sa_item() ------------------------------------------------------------

remove_sa_item(jsap = jsap_work, idx = 5L)
remove_sa_item(jsap = jsap_work, idx = 6L)


## remove_all_sa_item() --------------------------------------------------------

remove_all_sa_item(jsap = jsap_work)


# Wrangling 2 workspaces -------------------------------------------------------

## replace_sa_item() -----------------------------------------------------------

replace_sa_item(
    jsap = new_jsap,
    jsa = jsai_work,
    idx = 1L
)


## transfer_series() -----------------------------------------------------------

transfer_series(
    jsap_work = jsap_work,
    jsap_to = new_jsap,
    selected_series = c("RF0899", "RF1039", "RF1041")
)
