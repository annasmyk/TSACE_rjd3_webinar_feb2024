
# this functions will be add in the next version of rjd3providers

check_information <- function(jws,
                              idx_sap = NULL,
                              idx_sai = NULL) {

    if (!is.null(idx_sap) && max(idx_sap) > rjdemetra3::.jws_sap_count(jws)) {
        stop("The SAP n°", max(idx_sap), "doesn't exist")
    } else if (is.null(idx_sap)) {
        idx_sap <- seq_len(rjdemetra3::.jws_sap_count(jws))
    }

    for (id_sap in idx_sap) {
        jsap_i <- rjdemetra3::.jws_sap(jws, idx = id_sap)

        if (!is.null(idx_sai)
            && max(idx_sai) > rjdemetra3::.jsap_sa_count(jsap_i)) {
            stop("The SAI n°",  max(idx_sai),
                 " doesn't exist in the SAP n°", id_sap)
        }
    }

    return(invisible(TRUE))
}

spreadsheet_update_path <- function(jws,
                                    new_path,
                                    idx_sap = NULL,
                                    idx_sai = NULL) {

    check_information(jws = jws, idx_sap, idx_sai)

    idx_sap <- unique(idx_sap)
    idx_sai <- unique(idx_sai)

    if (is.null(idx_sap)) {
        idx_sap <- seq_len(rjdemetra3::.jws_sap_count(jws))
    }

    for (id_sap in idx_sap) {
        jsap <- rjdemetra3::.jws_sap(jws, idx = id_sap)

        idx_sai_tmp <- idx_sai
        if (is.null(idx_sai)) {
            idx_sai_tmp <- seq_len(rjdemetra3::.jsap_sa_count(jsap))
        }

        for (id_sai in idx_sai_tmp) {
            jsai <- rjdemetra3::.jsap_sa(jsap, idx = id_sai)

            old_jd3_ts <- rjdemetra3::get_ts(jsai)
            properties <- rjd3providers::spreadsheet_id_properties(old_jd3_ts$metadata$`@id`)
            properties$file <- new_path
            new_id <- rjd3providers::spreadsheet_to_id(properties)

            new_jd3_ts <- old_jd3_ts
            new_jd3_ts$metadata$`@id` <- new_id
            new_jd3_ts$moniker$id <- new_id
            new_jd3_ts$moniker$source <- new_jd3_ts$metadata$`@source`
            rjdemetra3::set_ts(jsap = jsap, idx = id_sai, y = new_jd3_ts)
        }
    }

    return(invisible(NULL))
}

txt_update_path <- function(jws,
                            new_path,
                            idx_sap = NULL,
                            idx_sai = NULL) {

    check_information(jws = jws, idx_sap, idx_sai)

    idx_sap <- unique(idx_sap)
    idx_sai <- unique(idx_sai)

    if (is.null(idx_sap)) {
        idx_sap <- seq_len(rjdemetra3::.jws_sap_count(jws))
    }

    for (id_sap in idx_sap) {
        jsap <- rjdemetra3::.jws_sap(jws, idx = id_sap)

        idx_sai_tmp <- idx_sai
        if (is.null(idx_sai)) {
            idx_sai_tmp <- seq_len(rjdemetra3::.jsap_sa_count(jsap))
        }

        for (id_sai in idx_sai_tmp) {
            jsai <- rjdemetra3::.jsap_sa(jsap, idx = id_sai)

            old_jd3_ts <- rjdemetra3::get_ts(jsai)
            properties <- rjd3providers::txt_id_properties(old_jd3_ts$metadata$`@id`)
            properties$file <- new_path
            new_id <- rjd3providers::txt_to_id(properties)

            new_jd3_ts <- old_jd3_ts
            new_jd3_ts$metadata$`@id` <- new_id
            new_jd3_ts$moniker$id <- new_id
            new_jd3_ts$moniker$source <- new_jd3_ts$metadata$`@source`
            rjdemetra3::set_ts(jsap = jsap, idx = id_sai, y = new_jd3_ts)
        }
    }

    return(invisible(NULL))
}
