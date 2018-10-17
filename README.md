# Semáforo 
Classe em advpl para controlar as rotinas que devem executar de forma excluisa




#Descrição
Fonte ADVPL Protheus 12. Função vai controlar para que uma rotina não execute simultaneamente, 
para garantir a integridade dos dados que estão sendo gerados por ela.



#Exemplo de Uso

User Function IMPORTACAODEPV

Local oSemaforo :=  Semaforo():New() 




oSemaforo:setName("IMPORTACAODEPV")


oSemaforo:setTry(10)


oSemaforo:setSleep(500)



If !oSemaforo:LockData()
  FreeObj(oSemaforo)
	Return .F.
EndIf


// FUNÇÃO

oSemaforo:Destroy()
FreeObj(oSemaforo)




Return .T.
