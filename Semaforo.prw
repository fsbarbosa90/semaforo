#include 'protheus.ch'
#include 'parmtype.ch'
#include 'fileio.ch'

/*------------------------------------------------------------------------------------------------------+
|FONTE: Semaforo                     |AUTHOR: Fernando Barbosa                | DATA: 11/10/2018        |
+-------------------------------------------------------------------------------------------------------+
|DESCRICAO | ROTINA RESPONSAVEL POR REALIZAR O CONTROLE DE SEMAFORO DAS FUNÇÕES PARA NÃO EXECUTAR       |
|          |MAIS DE UMA VEZ UMA ROTINA, DESTA FORMA DEIXAR ELA FORMA EXCLUSIVA				|
|          |                                                                                            |
|          |                                                                                            |
+-------------------------------------------------------------------------------------------------------+
|PARAMETRO |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
+-------------------------------------------------------------------------------------------------------+
|RETORNO   |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
+-------------------------------------------------------------------------------------------------------+
|ALTERACAO |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
|          |                                                                                            |
+-------------------------------------------------------------------------------------------------------+*/

#Define DIR 	'\semaforo\'
#Define EXT 	'lck'
#Define CLRF   	CHR(13) + CHR(10)

Class Semaforo

	Data nHandle 	// HANDLE DO ARQUIVO
	Data cName	// NOME DO ARQUIVO
	Data nTry	// QUANTAS TENTATIVAS VAI FAZER
	Data nSleep	// TEMPO ENTRE CADA TENTATIVA, PASSAR EM MILESEGUNDOS
	
	Method New()
	Method setName(cName)
	Method setTry(nTry)
	Method setSleep(nSleep)
	Method getFile()
	Method LockData()
	Method unLockData() 
	Method Destroy() 
	Method getLogFile() 

EndClass

// +----------------------------------+
// | CRIA A CLASSE E RETORNA O OBJETO |
// +----------------------------------+
Method New() Class Semaforo
****************************
Self:nHandle 	:= -1
Self:cName 	:= ""
Self:nTry 	:= 5
Self:nSleep 	:= 2000

// +-----------------------------+
// | SE NÃO TEM O DIRETORIO CRIA |
// +-----------------------------+
If !ExistDir(DIR)
	MakeDir(DIR)
EndIf

Return Self

// +------------------------------------+
// | SETA O NOME DO ARQUIVO DE SEMAFORO |
// +------------------------------------+
Method setName(cName) Class Semaforo
*************************************
Self:cName := "semaforo_" + AllTrim(Lower(cName))
Return  

// +--------------------------------------------------+
// | SETA O NUMERO DE TENTATIVAS DE TRAVAR O SEMAFORO |
// +--------------------------------------------------+
Method setTry(nTry) Class Semaforo
**********************************
Self:nTry := nTry
Return  

// +-------------------------------------------------------+
// | SETA O SLEEP ENTRE AS TENTATIVAS DE TRAVAR O SEMAFORO |
// +-------------------------------------------------------+
Method setSleep(nSleep) Class Semaforo
**************************************
Self:nSleep := nSleep
Return  

// +---------------------------------------------+
// | RETORNA O NOME DO ARQUIVO COM SEU DIRETORIO |
// +---------------------------------------------+
Method getFile() Class Semaforo
********************************
Return DIR + Self:cName + '.' + EXT

// +--------------------------------------------------+
// | TENTA TRAVAR O ARQUIVO PARA CONTROLAR O SEMAFORO |
// +--------------------------------------------------+
Method LockData() Class Semaforo
*********************************
Local nTry := 1 

While Self:nHandle == -1 .And. nTry <= Self:nTry
	nTry++
	Self:nHandle := fCreate(Self:getFile())	
	If Self:nHandle == -1 .And. nTry <= Self:nTry
		Sleep(Self:nSleep)
	EndIf	
EndDo

If Self:nHandle == -1
	Return .F.
EndIf

FSeek(Self:nHandle, 0, FS_END) 
FWrite(Self:nHandle, Self:getLogFile())

Return .T.

// +---------------------+
// | DESTRAVA O SEMAFORO |
// +---------------------+
Method unLockData() Class Semaforo
***********************************

FSeek(Self:nHandle, 0, FS_END) 
FWrite(Self:nHandle, "Data Final: " + AllTrim(dToC(Date())) + CLRF + "Hora Final: " + AllTrim(Time()))

If Self:nHandle != 1 .And. !FClose(Self:nHandle)
	Return .F.
EndIf

Self:nHandle := -1

Return .T.

// +------------------------------------+
// | DESTROI TODOS OS DADOS DE CONTROLE |
// +------------------------------------+
Method Destroy() Class Semaforo
********************************

If !Self:unLockData()
	Return .F.
EndIf

If File(Self:getFile()) .And. FErase(Self:getFile()) == -1
	Return .F.
EndIf

Self:nHandle 	:= -1
Self:cName 	:= ""

Return .T.

// +-----------------------------------------------------------------------------------+
// | MONTA A STRING DE LOG PARA GRAVAR NO ARQUIVO PARA SABER QUEM ESTA MANIPULANDO ELE |
// +-----------------------------------------------------------------------------------+
Method getLogFile() Class Semaforo
***********************************
Local cLog := ""
 
cLog := "Data Inicio: " 	+ AllTrim(dToC(Date())) + CLRF
cLog += "Hora Inicio: " 	+ AllTrim(Time()) + CLRF
cLog += "Usuario: " 		+ AllTrim(__cUserId) + CLRF
cLog += "Nome: " 		+ AllTrim(UsrFullName(__cUserId)) + CLRF
cLog += "Ambiente: " 		+ AllTrim(GetEnvServer()) + CLRF
cLog += "IP: " 			+ AllTrim(GetClientIP()) + CLRF
cLog += "Nome da Maquina: " 	+ AllTrim(GetComputerName()) + CLRF
cLog += "Host: " 		+ AllTrim(GetEnvHost()) + CLRF
cLog += "ID Thread: " 		+ AllTrim(cValToChar(ThreadID())) + CLRF
cLog += "Service Name: " 	+ AllTrim(GetPvProfString("SERVICE","NAME","","APPSERVER.INI")) + CLRF
cLog += "Service DisplayName: " + AllTrim(GetPvProfString("SERVICE","DISPLAYNAME","","APPSERVER.INI")) + CLRF

Return cLog