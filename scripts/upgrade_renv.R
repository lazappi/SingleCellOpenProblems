upgraded_remote_version <- function(remote) {
  if (remote$Source == "Repository") {
    out <- paste0(remote$Package, "@", remote$Version)
    if (remote$Repository == "BioCsoft") {
      out <- paste0("bioc::", out)
    }
  } else if (remote$Source == "GitHub") {
    out <- paste0(
      remote$RemoteUsername, "/", remote$RemoteRepo, "@", remote$RemoteSha[1:7]
    )
    if (remote$RemoteRef != remote$RemoteSha) {
      out <- paste0(out, " # ", remote$RemoteRef)
    }
  }
  return(out)
}

upgrade_first_available <- function(remotes) {
  for (remote in remotes) {
    cat(paste0(remote, "\n"))
    parsed_spec <- renv:::renv_remotes_parse(remote)
    package <- parsed_spec$package
    if (is.null(package)) {
      package <- parsed_spec$repo
    }
    result <- renv::update(package, prompt = FALSE)
    if (class(result) != "logical") {
      upgraded_remotes <- sapply(result, upgraded_remote_version)
      primary <- upgraded_remotes[[package]]
      return(list(primary = primary, upgraded = upgraded_remotes))
    }
  }
}

check_pinned <- function(remote) {
  length(grep("#.*pinned", remote)) == 0
}

drop_pinned <- function(remotes) {
  remotes[sapply(remotes, check_pinned)]
}

strip_comments <- function(remote) {
  gsub("\\s*#.*", "", remote)
}

write_updates_to_file <- function(curr_remotes, new_remotes, filename) {
  current_names <- gsub("@.*", "", curr_remotes)
  new_names <- gsub("@.*", "", new_remotes)
  keep_current <- !(current_names %in% new_names)
  write_remotes <- sort(c(curr_remotes[keep_current], new_remotes))
  writeLines(write_remotes, filename, sep = "\n")
}

upgrade_renv <- function(requirements_file) {
  remotes <- scan(requirements_file, what = character(), sep = "\n")
  if (length(remotes) > 0) {
    remotes_parsed <- drop_pinned(remotes)
    remotes_parsed <- sapply(remotes_parsed, strip_comments)
    upgraded_remotes <- upgrade_first_available(remotes_parsed)
    if (!is.null(upgraded_remotes)) {
      cat("\nUpgrades are available:\n")
      cat(paste(upgraded_remotes$upgraded, collapse = "\n"))
      cat("\n")
      write_updates_to_file(
        remotes, upgraded_remotes$upgraded, requirements_file
      )
      cat(paste0("\nUpgrade triggered by:\n", upgraded_remotes$primary, "\n"))
    } else {
      cat("\nNo upgrades available\n\n")
    }
  } else {
    cat("\n")
  }
}

suppressWarnings(upgrade_renv(commandArgs(trailingOnly = TRUE)[1]))
