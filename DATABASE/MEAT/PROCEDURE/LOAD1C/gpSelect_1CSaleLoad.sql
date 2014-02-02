-- Function: gpSelect_1CSaleLoad(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_1CSaleLoad (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_1CSaleLoad(
    IN inStartDate        TDateTime , -- 
    IN inEndDate          TDateTime , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, UnitId Integer, VidDoc TVarChar, InvNumber TVarChar,
               OperDate TDateTime, ClientCode Integer, ClientName TVarChar, 
               GoodsCode Integer, GoodsName TVarChar, OperCount TFloat, OperPrice TFloat,
               Tax TFloat, Doc1Date TDateTime, Doc1Number TVarChar, Doc2Date TDateTime, Doc2Number TVarChar,
               Suma TFloat, PDV TFloat, SumaPDV TFloat, ClientINN TVarChar, ClientOKPO TVarChar,
               InvNalog TVarChar, BillId Integer, EkspCode Integer, ExpName TVarChar,
               DeliveryPointId Integer, DeliveryPointName TVarChar,
               GoodsGoodsKindId Integer, GoodsGoodsKindName TVarChar
)

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Branch());

   -- Результат
   RETURN QUERY 
   SELECT   
      Sale1C.Id          ,
      Sale1C.UnitId      ,
      Sale1C.VidDoc      ,
      Sale1C.InvNumber   ,
      Sale1C.OperDate    ,
      Sale1C.ClientCode  ,   
      Sale1C.ClientName  ,   
      Sale1C.GoodsCode   ,   
      Sale1C.GoodsName   ,   
      Sale1C.OperCount   ,
      Sale1C.OperPrice   ,
      Sale1C.Tax         ,
      Sale1C.Doc1Date    ,
      Sale1C.Doc1Number  ,
      Sale1C.Doc2Date    ,
      Sale1C.Doc2Number  ,
      Sale1C.Suma        ,
      Sale1C.PDV         ,
      Sale1C.SumaPDV     ,
      Sale1C.ClientINN   ,
      Sale1C.ClientOKPO  ,
      Sale1C.InvNalog    ,
      Sale1C.BillId      ,
      Sale1C.EkspCode    ,
      Sale1C.ExpName     ,
      0::Integer,
      ''::TVarChar,
      0::Integer,
      ''::TVarChar

   FROM Sale1C;

select Object_Partner.*, Object_DeliveryPoint.*, Sale1C.* 

   FROM Sale1C

 LEFT JOIN Object AS Object_DeliveryPoint ON Sale1C.ClientCode = Object_DeliveryPoint.ObjectCode
 AND Object_DeliveryPoint.DescId =  zc_Object_Partner1CLink()
     LEFT JOIN ObjectLink AS ObjectLink_Partner1CLink_Partner
         ON ObjectLink_Partner1CLink_Partner.ObjectId = Object_DeliveryPoint.Id
        AND ObjectLink_Partner1CLink_Partner.DescId = zc_ObjectLink_Partner1CLink_Partner()
  LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner1CLink_Partner.ChildObjectId   

 order by 2
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_1CSaleLoad(TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.13                         * 
*/

-- тест
-- SELECT * FROM gpSelect_Object_Branch (zfCalc_UserAdmin())