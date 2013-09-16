-- Function: lfSelect_ContainerSumm_byAccount (Integer)

-- DROP FUNCTION lfSelect_ContainerSumm_byAccount (Integer);

CREATE OR REPLACE FUNCTION lfSelect_ContainerSumm_byAccount (inAccountId Integer)
RETURNS TABLE (ContainerId Integer, AccountId Integer, JuridicalId_basis Integer, BusinessId Integer, GoodsId Integer)  
AS
$BODY$
BEGIN

     -- Выбираем данные для справочника счетов (на самом деле это три справочника)
     RETURN QUERY
       SELECT Container_Summ.Id AS ContainerId
            , Container_Summ.ObjectId AS AccountId
            , COALESCE (ContainerLinkObject_JuridicalBasis.ObjectId, 0) AS JuridicalId_basis
            , COALESCE (ContainerLinkObject_Business.ObjectId, 0) AS BusinessId
            , COALESCE (ContainerLinkObject_Goods.ObjectId, 0) AS GoodsId
       FROM Container AS Container_Summ
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_JuridicalBasis
                                          ON ContainerLinkObject_JuridicalBasis.ContainerId = Container_Summ.Id
                                         AND ContainerLinkObject_JuridicalBasis.DescId = zc_ContainerLinkObject_JuridicalBasis()
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Business
                                          ON ContainerLinkObject_Business.ContainerId = Container_Summ.Id
                                         AND ContainerLinkObject_Business.DescId = zc_ContainerLinkObject_Business()
            LEFT JOIN ContainerLinkObject AS ContainerLinkObject_Goods
                                          ON ContainerLinkObject_Goods.ContainerId = Container_Summ.Id
                                         AND ContainerLinkObject_Goods.DescId = zc_ContainerLinkObject_Goods()
       WHERE Container_Summ.ObjectId = zc_Enum_Account_20901() -- 20901; Оборотная тара
         AND Container_Summ.DescId = zc_Container_Summ();

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lfSelect_ContainerSumm_byAccount (Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.13                                        *
*/

-- тест
-- SELECT * FROM lfSelect_ContainerSumm_byAccount (zc_Enum_Account_20901())
