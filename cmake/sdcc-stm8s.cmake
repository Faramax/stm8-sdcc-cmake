set(STM8_CHIP_TYPES
        208
        207
        007
        105
        005
        103
        003
        903)

set(STM8_CODES
        208[CMRS][68B]
        207[CKMRS][68B]
        007[C][8]
        105[CKS][46]
        005[CK][6]
        103[FK][23]
        003[FK][3]
        903[FK][3]
        )

macro(STM8_GET_CHIP_TYPE CHIP CHIP_TYPE)
    string(TOUPPER ${CHIP} CHIP_UPPER)
    string(REGEX REPLACE "^[sS][tT][mM]8[sS]( ([0129][0][3578][CFKMRS][23468B]) )+$" "\\1" STM8_CODE ${CHIP_UPPER})
    if(STM8_CODE)
        message(STATUS "STM8_CODE: ${STM8_CODE}")
    else()
        message(FATAL_ERROR "Couldn't recognize STM8AF chip code: ${CHIP}\n\
            Available chip codes: ${STM8_CODE_REGEX}")
    endif()
    set(INDEX 0)
    foreach(TYPE ${STM8_CHIP_TYPES})
        list(GET STM8_CODES ${INDEX} CHIP_TYPE_REGEX)
        if(STM8_CODE MATCHES ${CHIP_TYPE_REGEX})
            set(RESULT_TYPE ${TYPE})
        endif()
        MATH(EXPR INDEX "${INDEX}+1")
    endforeach()
    if(RESULT_TYPE)
        message(STATUS "CHIP_TYPE: ${RESULT_TYPE}")
    else ()
        message(FATAL_ERROR "Couldn't recognize STM8AF chip type: ${CHIP}\n\
            Available chip types: STM8AF..${STM8_CHIP_TYPES}")
    endif()
    set(${CHIP_TYPE} ${RESULT_TYPE})
endmacro()


function(STM8_SET_CHIP_DEFINITIONS TARGET CHIP_TYPE)
    list(FIND STM8_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    if(TYPE_INDEX EQUAL -1)
        message(FATAL_ERROR "Invalid/unsupported STM8L chip type: ${CHIP_TYPE}")
    endif()
    get_target_property(TARGET_DEFS ${TARGET} COMPILE_DEFINITIONS)
    if(TARGET_DEFS)
        set(TARGET_DEFS "STM8L${CHIP_TYPE};${TARGET_DEFS}")
    else()
        set(TARGET_DEFS "STM8L${CHIP_TYPE}")
    endif()
    set_target_properties(${TARGET} PROPERTIES COMPILE_DEFINITIONS "${TARGET_DEFS}")
endfunction()

function(STM8_SET_PROJECT_DEFINITIONS CHIP_TYPE)
    message(STATUS "STM8_SET_PROJECT_DEFINITIONS with CHIP_TYPE:${CHIP_TYPE}")
    list(FIND STM8_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    if(TYPE_INDEX EQUAL -1)
        message(FATAL_ERROR "Invalid/unsupported chip type: ${CHIP_TYPE}\n\
            Available chip types: STM8S..${STM8_CHIP_TYPES}")
    endif()
    add_compile_definitions(STM8S${CHIP_TYPE})
endfunction()