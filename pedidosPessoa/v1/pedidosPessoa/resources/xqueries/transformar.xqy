xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)


declare namespace ns4="http://service.sciensa.com.br/v1/pedidosPessoa";
(:: import schema at "../../../../../canonico/visao/v1/pedidosPessoa/pedidosPessoaView.xsd" ::)
declare namespace ns3="http://xmlns.oracle.com/pcbpel/adapter/db/sp/db_PROC_BUSCA_PEDIDO";
(:: import schema at "../../../../../pedidosPessoa/v1/pedidosPessoa/resources/adapters/dbadapter/db_PROC_BUSCA_PEDIDO_sp.xsd" ::)
declare namespace ns2="http://xmlns.oracle.com/pcbpel/adapter/db/sp/db_PROC_BUSCA_PESSOA";
(:: import schema at "../../../../../pedidosPessoa/v1/pedidosPessoa/resources/adapters/dbadapter/db_PROC_BUSCA_PESSOA_sp.xsd" ::)

declare namespace ped = "http://domain.sciensa.com.br/v1/pedidosPessoa";

declare variable $pessoaRS as element() (:: schema-element(ns2:OutputParameters) ::) external;
declare variable $pedidoRS as element() (:: schema-element(ns3:OutputParameters) ::) external;


declare function local:func1($pessoaRS as element() (:: schema-element(ns2:OutputParameters) ::), 
                          $pedidoRS as element() (:: schema-element(ns3:OutputParameters) ::)) 
                          as element() (:: schema-element(ns4:PessoaResponse) ::) {
   <ns4:PessoaResponse>
   {
      for $pessoa in $pessoaRS/ns2:RowSet
      return
       <ped:Pessoa>
            {
              if ($pessoa/*:Row/*:Column/@name="FirstName")
              then <ped:nome>{fn:data($pessoa/*:Row/*:Column[@name="FirstName"])}</ped:nome>
              else (<ped:nome></ped:nome>)
            }
            {
              if ($pessoa/*:Row/*:Column/@name="LastName")
              then <ped:sobrenome>{fn:data($pessoa/*:Row/*:Column[@name="LastName"])}</ped:sobrenome>
              else (<ped:sobrenome></ped:sobrenome>)
            }            
            {
            
              if ($pessoa/*:Row/*:Column/@name="BithDate")
              then 
                <ped:idade>{
                    xs:int(xs:int(fn:days-from-duration(fn:current-date() - xs:date(fn:data($pessoa/*:Row/*:Column[@name="BithDate"])))) div xs:decimal("365.25"))
                   }</ped:idade>
              else (<ped:idade></ped:idade>)
            }

            {
              for $pedido in $pedidoRS/*:RowSet/*:Row
              return 
               <ped:pedidos>
                  <ped:id>
                  {fn:data($pedido/*:Column[@name="OrderID"])}
                  </ped:id>
                  <ped:valor>{fn:data($pedido/*:Column[@name="Value"])}</ped:valor>
               </ped:pedidos>              
            }

       </ped:Pessoa>
   }
   </ns4:PessoaResponse>
    
  
};
local:func1($pessoaRS, $pedidoRS)

