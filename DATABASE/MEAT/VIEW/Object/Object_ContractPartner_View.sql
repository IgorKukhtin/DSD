-- View: Object_ContractPartner_View

-- DROP VIEW IF EXISTS Object_ContractPartner_View;

CREATE OR REPLACE VIEW Object_ContractPartner_View
AS
        SELECT ObjectLink_ContractPartner_Contract.ObjectId      AS Id
             , ObjectLink_ContractPartner_Contract.ChildObjectId AS ContractId
             , ObjectLink_ContractPartner_Partner.ChildObjectId  AS PartnerId
             , Object_ContractPartner.isErased
         FROM ObjectLink AS ObjectLink_ContractPartner_Contract
              INNER JOIN ObjectLink AS ObjectLink_ContractPartner_Partner
                                    ON ObjectLink_ContractPartner_Partner.ObjectId = ObjectLink_ContractPartner_Contract.ObjectId
                                   AND ObjectLink_ContractPartner_Partner.DescId = zc_ObjectLink_ContractPartner_Partner()
              LEFT JOIN Object AS Object_ContractPartner ON Object_ContractPartner.Id = ObjectLink_ContractPartner_Contract.objectid 
         WHERE ObjectLink_ContractPartner_Contract.DescId = zc_ObjectLink_ContractPartner_Contract()
        ;

ALTER TABLE Object_ContractPartner_View  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ÈÑÒÎĞÈß ĞÀÇĞÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎĞ
               Ôåëîíşê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 22.04.15                                        *
*/

-- òåñò
-- SELECT * FROM Object_ContractPartner_View
