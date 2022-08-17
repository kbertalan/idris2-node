module Console

import Data.Buffer.Ext
import Data.String
import Node.Console
import Node.Process

%foreign "node:lambda: () => ({ a: 1, b: 2 })"
ffi_object : AnyPtr

%foreign "node:lambda: () => [1, '2', 3.4]"
ffi_array : AnyPtr

main : IO ()
main = do
  console.log "using console"

  console.log "log"
  console.log ffi_object
  console.log ffi_array

  console.debug "debug"
  console.debug ffi_object
  console.debug ffi_array

  -- logs to standard error, so it is not compared to expected output
  -- console.error "error"
  -- console.error ffi_object
  -- console.error ffi_array

  console.info "info"
  console.info ffi_object
  console.info ffi_array

  -- puts traces to standard error, so it is not compared to expected output
  -- console.trace "trace"
  -- console.trace ffi_object
  -- console.trace ffi_array

  -- logs to standard error, so it is not compared to expected output
  -- console.warn "warn"
  -- console.warn ffi_object
  -- console.warn ffi_array

  process <- Process.require
  consoleM <- Console.require
  let opts : Console.Options StdOut StdOut = { colorMode := Enabled } (defaultOptions process.stdout process.stdout)
  logger <- consoleM.newConsole opts 

  logger.log "using logger"

  logger.log "log"
  logger.log ffi_object
  logger.log ffi_array

  logger.debug "debug"
  logger.debug ffi_object
  logger.debug ffi_array

  logger.error "error"
  logger.error ffi_object
  logger.error ffi_array

  logger.info "info"
  logger.info ffi_object
  logger.info ffi_array

  -- prints current path to output, thus it would fail on different computers
  -- logger.trace "trace"
  -- logger.trace ffi_object
  -- logger.trace ffi_array

  logger.warn "warn"
  logger.warn ffi_object
  logger.warn ffi_array
