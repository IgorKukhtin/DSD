-- Function: gpGet_Goods_Juridical_value()

DROP FUNCTION IF EXISTS gpGet_Goods_Juridical_value (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Goods_Juridical_value(
    IN inDiscountExternal Integer    , --
    IN inGoodsId          Integer    , --
    IN inAmount           TFloat     , --
   OUT outJuridicalID     Integer    , --
   OUT outCodeRazom       Integer    , --
   OUT outInvoiceNumber   TVarChar   , --
   OUT outInvoiceDate     TDateTime  , --
   OUT outContainerID     Integer    , --
   OUT outDiscountProcent TFloat     , --
   OUT outDiscountSum     TFloat     , --
    IN inSession          TVarChar     --
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    IF inDiscountExternal = 15645454 AND CURRENT_DATE >= '01.08.2021'
    THEN
      RAISE EXCEPTION 'Срок действия дисконтной программы завершен.';
    END IF;

    outDiscountProcent := 0;
    outDiscountSum     := 0;

    WITH
         tmpDiscountExternal AS (SELECT Object_DiscountExternal.ObjectCode
                                      , COALESCE(ObjectBoolean_OneSupplier.ValueData, False)      AS isOneSupplier
                                      , COALESCE(ObjectBoolean_TwoPackages.ValueData, False)      AS isTwoPackages
                                 FROM Object AS Object_DiscountExternal
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_OneSupplier
                                                              ON ObjectBoolean_OneSupplier.ObjectId = Object_DiscountExternal.Id
                                                             AND ObjectBoolean_OneSupplier.DescId = zc_ObjectBoolean_DiscountExternal_OneSupplier()
                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_TwoPackages
                                                              ON ObjectBoolean_TwoPackages.ObjectId = Object_DiscountExternal.Id
                                                             AND ObjectBoolean_TwoPackages.DescId = zc_ObjectBoolean_DiscountExternal_TwoPackages()
                                 WHERE Object_DiscountExternal.ID = inDiscountExternal)
       , tmpSupplier AS (SELECT ObjectLink_Juridical.ChildObjectId     AS JuridicalId
                              , ObjectFloat_SupplierID.ValueData::Integer   AS SupplierID
                         FROM Object AS Object_DiscountExternalSupplier
                              LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                   ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                  AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                              LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                   ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                  AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()

                              LEFT JOIN ObjectFloat AS ObjectFloat_SupplierID
                                                    ON ObjectFloat_SupplierID.ObjectId = Object_DiscountExternalSupplier.Id
                                                   AND ObjectFloat_SupplierID.DescId = zc_ObjectFloat_DiscountExternalSupplier_SupplierID()

                         WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                           AND Object_DiscountExternalSupplier.isErased = False
                           AND ObjectLink_DiscountExternal.ChildObjectId = inDiscountExternal
                         )
       , tmpContainerAll AS (SELECT Container.Id
                                  , FLOOR(Container.Amount) AS Amount
                             FROM Container
                             WHERE Container.DescId = zc_Container_Count()
                               AND Container.Amount >= 1
                               AND Container.WhereObjectId = vbUnitId
                               AND Container.ObjectId = inGoodsId
                              )
       , tmpContainer AS (SELECT CASE WHEN tmpDiscountExternal.isOneSupplier = False
                                      THEN SUM(Container.Amount)
                                      ELSE FLOOR (SUM(Container.Amount)) END                     AS Amount
                               , MovementLinkObject_From.ObjectId                                AS JuridicalID
                               , MovementLinkObject_To.ObjectId                                  AS UnitID
                               , COALESCE(tmpSupplier.SupplierID, 0)::Integer                    AS CodeRazom
                               , MIN(Container.Id)                                               AS Id
                               , MIN(COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)) AS MIncomeId
                          FROM tmpContainerAll AS Container
                                LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                              ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                             AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                -- элемент прихода
                                LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                                -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                                LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                                -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                                LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)
                                                                     -- AND 1=0

                                LEFT JOIN Movement AS Movement_Income ON Movement_Income.Id = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                             ON MovementLinkObject_From.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                             ON MovementLinkObject_To.MovementId = COALESCE (MI_Income_find.MovementId ,MI_Income.MovementId)
                                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                                LEFT JOIN tmpSupplier ON tmpSupplier.JuridicalId = MovementLinkObject_From.ObjectId

                                LEFT JOIN tmpDiscountExternal ON 1 = 1

                          WHERE COALESCE(tmpSupplier.SupplierID, 0) > 0
                            AND (inDiscountExternal <> 15645454 OR Movement_Income.OperDate < '01.05.2021')
                          GROUP BY MovementLinkObject_From.ObjectId
                                 , MovementLinkObject_To.ObjectId
                                 , COALESCE(tmpSupplier.SupplierID, 0)
                                 , tmpDiscountExternal.isOneSupplier
                          )
       , tmpRemains AS (SELECT Sum(Container.Amount) AS Remains
                        FROM tmpContainer AS Container)

    SELECT Container.JuridicalID, Container.CodeRazom, Movement.InvNumber, Movement.OperDate, Container.Id
    INTO outJuridicalID, outCodeRazom, outInvoiceNumber, outInvoiceDate, outContainerID
    FROM tmpContainer AS Container
         LEFT JOIN Movement ON Movement.ID = Container.MIncomeId
         LEFT JOIN tmpRemains ON 1 = 1
         LEFT JOIN tmpDiscountExternal ON 1 = 1
    WHERE tmpRemains.Remains >= inAmount
    ORDER BY Container.UnitId <> vbUnitId, Movement.OperDate
    LIMIT 1;
    
    SELECT COALESCE(ObjectFloat_DiscountProcent.ValueData, 0)
        ,  CASE WHEN COALESCE(ObjectFloat_DiscountProcent.ValueData, 0) <> 0 
                THEN 0
                WHEN COALESCE(ObjectFloat_DiscountWithVAT.ValueData, 0) <> 0 
                THEN COALESCE(ObjectFloat_DiscountWithVAT.ValueData, 0)
                WHEN COALESCE(ObjectFloat_DiscountWithoutVAT.ValueData, 0) <> 0 
                THEN ROUND(COALESCE(ObjectFloat_DiscountWithoutVAT.ValueData, 0) * (100 + COALESCE(ObjectFloat_NDSKind_NDS.ValueData)) / 100, 2) END
    INTO outDiscountProcent, outDiscountSum
    FROM Object AS Object_BarCode
         INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                              ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                             AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                             AND ObjectLink_BarCode_Goods.ChildObjectId = inGoodsId
             
         INNER JOIN ObjectLink AS ObjectLink_BarCode_Object
                               ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                              AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                              AND ObjectLink_BarCode_Object.ChildObjectId = inDiscountExternal         

         LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                               ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                              AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()
         LEFT JOIN ObjectFloat AS ObjectFloat_DiscountWithVAT
                               ON ObjectFloat_DiscountWithVAT.ObjectId = Object_BarCode.Id
                              AND ObjectFloat_DiscountWithVAT.DescId = zc_ObjectFloat_BarCode_DiscountWithVAT()
         LEFT JOIN ObjectFloat AS ObjectFloat_DiscountWithoutVAT
                               ON ObjectFloat_DiscountWithoutVAT.ObjectId = Object_BarCode.Id
                              AND ObjectFloat_DiscountWithoutVAT.DescId = zc_ObjectFloat_BarCode_DiscountWithoutVAT()

         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = inGoodsId
         LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                    
         LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId
                              AND ObjectFloat_NDSKind_NDS.DescId   = zc_ObjectFloat_NDSKind_NDS()
                              
    WHERE Object_BarCode.DescId = zc_Object_BarCode()
      AND Object_BarCode.isErased = False;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Goods_Juridical_value (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.04.20                                                       *
 19.11.19                                                       *
*/

-- тест
--  select * from gpGet_Goods_Juridical_value(inDiscountExternal := 2807930 , inGoodsId := 12673 , inAmount := 1 ,  inSession := '3');

--select * from gpGet_Goods_Juridical_value_Ol(inDiscountExternal := 15466976 , inGoodsId := 2431326 , inAmount := 2 ,  inSession := '3');


select * from gpGet_Goods_Juridical_value(inDiscountExternal := 2807930 , inGoodsId := 644105 , inAmount := 1 ,  inSession := '3');