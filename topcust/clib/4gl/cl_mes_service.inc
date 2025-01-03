#-------------------------------------------------------------------------------
# File: cws_bpm.inc
# GENERATED BY fglwsdl 112734
#-------------------------------------------------------------------------------
# THIS FILE WAS GENERATED. DO NOT MODIFY.
#-------------------------------------------------------------------------------


GLOBALS

#
# Global WebService error structure
# Check the contents of this structure for a detailed error description
# when a WebService function returns with a non-zero status.
#

DEFINE wsError RECORD
	code		STRING,
	codeNS		STRING,
	description	STRING,
	action		STRING
END RECORD




#
# Global Endpoint user-defined type definition
#
TYPE tGlobalEndpointType RECORD	 # End point
	Address	RECORD	# Address
		Uri	STRING	# URI 
	END RECORD,
	Binding	RECORD	# Binding
		Version	STRING,	# HTTP Version (1.0 or 1.1)
		Cookie	STRING,	# Cookie to be set
		ConnectionTimeout	INTEGER,# Connection timeout
		ReadWriteTimeout	INTEGER	# Read write timeout
	END RECORD
END RECORD


#-------------------------------------------------------------------------------
# Service: ForewinWipToErpService
# Port:    ForewinWipToErp
# Server:  http://192.168.1.247:8080/WebService/ForewinWipToErp.asmx
#-------------------------------------------------------------------------------
#
# Location of the SOAP endpoint.
# You can reassign this value at run-time.
#
DEFINE ForewinWipToErpService tGlobalEndpointType

#-------------------------------------------------------------------------------

# VARIABLE : getMesktReasonRequest
DEFINE getMesktReasonRequest RECORD ATTRIBUTE(XMLSequence,XMLName="Get_Mes_kt_reason",XMLNamespace="http://tempuri.org/")
         wo_no STRING ATTRIBUTE(XMLName="wo_no",XMLNamespace="http://tempuri.org/")
       END RECORD

#-------------------------------------------------------------------------------

# VARIABLE : invokeProcessByOrgResponse
DEFINE getMesktReasonResponse RECORD ATTRIBUTE(XMLSequence,XMLName="Get_Mes_kt_reasonResponse",XMLNamespace="http://tempuri.org/")
         getMesktReasonReturn STRING ATTRIBUTE(XMLName="Get_Mes_kt_reasonResult",XMLNamespace="http://tempuri.org/")
       END RECORD

 

# VARIABLE : getDelMesUseNoRequest
DEFINE getDelMesUseNoRequest RECORD ATTRIBUTE(XMLSequence,XMLName="Del_Mes_Use_no",XMLNamespace="http://tempuri.org/")
         use_no STRING ATTRIBUTE(XMLName="use_no",XMLNamespace="http://tempuri.org/")
       END RECORD

#-------------------------------------------------------------------------------

# VARIABLE : getDelMesUsenoResponse
DEFINE getDelMesUseNoResponse RECORD ATTRIBUTE(XMLSequence,XMLName="Del_Mes_Use_noResponse ",XMLNamespace="http://tempuri.org/")
         getDelMesUseNoReturn STRING ATTRIBUTE(XMLName="Del_Mes_Use_noResult",XMLNamespace="http://tempuri.org/")
       END RECORD

#-------------------------------------------------------------------------------
# VARIABLE : getGetWaitScrapRequest
DEFINE getGetWaitScrapRequest RECORD ATTRIBUTE(XMLSequence,XMLName="Get_Wait_scrap",XMLNamespace="http://tempuri.org/")
    wo_nos STRING ATTRIBUTE(XMLName="wo_nos",XMLNamespace="http://tempuri.org/")
END RECORD

# VARIABLE : getGetWaitScrapResponse
DEFINE getGetWaitScrapResponse RECORD ATTRIBUTE(XMLSequence,XMLName="Get_Wait_scrapResponse ",XMLNamespace="http://tempuri.org/")
    getGetWaitScrapReturn STRING ATTRIBUTE(XMLName="Get_Wait_scrapResult",XMLNamespace="http://tempuri.org/")
END RECORD
#-------------------------------------------------------------------------------


END GLOBALS
