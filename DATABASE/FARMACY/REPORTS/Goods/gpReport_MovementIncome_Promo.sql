  -- Function: gpReport_MovementIncome_Promo()

DROP FUNCTION IF EXISTS gpReport_MovementIncome_Promo (Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome_Promo(
    IN inMakerId       Integer     -- Производитель
  , IN inStartDate     TDateTime 
  , IN inEndDate       TDateTime
  , IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (MovementId Integer      --ИД Документа
             , ItemName TVarChar       --Название(тип) документа
             , StatusName TVarChar     --Состояние документа
             , Amount TFloat           --Кол-во товара в документе
             , Code Integer            --Код товара
             , Name TVarChar           --Наименование товара
             , PartnerGoodsName TVarChar  --Наименование поставщика
             , MakerName  TVarChar     --Производитель
             , NDSKindName TVarChar    --вид ндс
             , NDS         TFloat      -- % ндс
             , MorionCode Integer      -- Код мориона
             , OperDate TDateTime      --Дата документа
             , InvNumber TVarChar      --№ документа
             , UnitID Integer          --ID Подразделение
             , UnitName TVarChar       --Подразделение
             , MainJuridicalId Integer  --Наше Юр. лицо
             , MainJuridicalName TVarChar  --Наше Юр. лицо
             , JuridicalId Integer     --Юр. лицо
             , JuridicalName TVarChar  --Юр. лицо
             , RetailName TVarChar     --Торговая сеть
             , Price TFloat            --Цена в документе
             , Summa TFloat            --Сумма в документе
             , PriceWithVAT TFloat     --Цена прихода с НДС 
             , SummaWithVAT TFloat     --Сумма прихода с НДС 
             , PriceSale TFloat        --Цена продажи
             , PriceSIP TFloat         --Цена СИП
             , SummSIP TFloat          --Сумма СИП
             , PartionGoods TVarChar   --№ серии препарата
             , ExpirationDate TDateTime--Срок годности
             , PaymentDate TDateTime   --Дата оплаты
             , InvNumberBranch TVarChar--№ накладной в аптеке
             , BranchDate TDateTime    --Дата накладной в аптеке
             , InsertDate TDateTime    --Дата (созд.)
             , isChecked  Boolean      -- для маркетинга
             , isReport   Boolean      -- для отчета
             , isSendMaker Boolean     -- для отчета производителю
             , GoodsGroupPromoName TVarChar -- Группы товаров для маркетинга
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpGetUserBySession (inSession);

    inEndDate := inEndDate+interval '1 day';

    RETURN QUERY
    WITH 
    -- Id строк Маркетинговых контрактов inMakerId
    tmpMIPromo AS (SELECT DISTINCT MI_Goods.Id               AS MI_Id
                        , MI_Goods.ObjectId                  AS GoodsId
                        , MovementDate_StartPromo.ValueData  AS StartDate_Promo
                        , MovementDate_EndPromo.ValueData    AS EndDate_Promo
                        , MIFloat_Price.ValueData            AS Price
                        , COALESCE (MIBoolean_Checked.ValueData, FALSE)                                           ::Boolean  AS isChecked
                        , CASE WHEN COALESCE (MIBoolean_Checked.ValueData, FALSE) = TRUE THEN FALSE ELSE TRUE END ::Boolean  AS isReport
                   FROM Movement
                     INNER JOIN MovementLinkObject AS MovementLinkObject_Maker
                                                   ON MovementLinkObject_Maker.MovementId = Movement.Id
                                                  AND MovementLinkObject_Maker.DescId = zc_MovementLinkObject_Maker()
                                                  AND MovementLinkObject_Maker.ObjectId = inMakerId 

                     INNER JOIN MovementDate AS MovementDate_StartPromo
                                             ON MovementDate_StartPromo.MovementId = Movement.Id
                                            AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                     INNER JOIN MovementDate AS MovementDate_EndPromo
                                             ON MovementDate_EndPromo.MovementId = Movement.Id
                                            AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                     INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                                        AND MI_Goods.DescId = zc_MI_Master()
                                                        AND MI_Goods.isErased = FALSE
                     LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                 ON MIFloat_Price.MovementItemId = MI_Goods.Id
                                                AND MIFloat_Price.DescId = zc_MIFloat_Price()
                     LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                   ON MIBoolean_Checked.MovementItemId = MI_Goods.Id
                                                  AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                   WHERE Movement.StatusId = zc_Enum_Status_Complete()
                     AND Movement.DescId = zc_Movement_Promo()
                    )

   -- выбираем все строки документов прихода с маркет. товарами
  , tmpMovMIComplete_All AS (SELECT Movement.Id                       AS MovementId
                                  , Movement.DescId                   AS DescId
                                  , Movement.StatusId                 AS StatusId 
                                  , Movement.OperDate                 AS OperDate
                                  , Movement.InvNumber                AS InvNumber
                                  , MIContainer.MovementItemId        AS MovementItemId
                                  , MIContainer.ObjectId_analyzer     AS GoodsId
                                  , COALESCE (MIContainer.Amount, 0)  AS Amount
                                  , tmpMIPromo.Price                  AS PriceSIP
                                  , tmpMIPromo.isChecked
                                  , tmpMIPromo.isReport
                             FROM Movement 
                                INNER JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.MovementId = Movement.Id
                                                                AND MIContainer.DescId = zc_MIContainer_Count()
                                                                AND MIContainer.MovementDescId = zc_Movement_Income()
                                                                AND COALESCE (MIContainer.ObjectIntId_analyzer,0) <> 0
    
                                INNER JOIN tmpMIPromo ON tmpMIPromo.MI_Id = MIContainer.ObjectIntId_analyzer
                               
                             WHERE Movement.DescId = zc_Movement_Income()
                               AND Movement.StatusId = zc_Enum_Status_Complete()
                               AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                             --AND Movement.OperDate >= '01.01.2018'/*inStartDate*/ AND Movement.OperDate < '20.02.2018' /*inEndDate */
                               AND COALESCE (inMakerId,0) <> 0
                           )

  , tmpMovMI_UnComplete_All AS (SELECT Movement.Id                     AS MovementId
                                     , Movement.DescId                 AS DescId
                                     , Movement.StatusId               AS StatusId 
                                     , Movement.OperDate               AS OperDate
                                     , Movement.InvNumber              AS InvNumber
                                     , MovementItem.Id                 AS MovementItemId
                                     , MovementItem.ObjectId           AS GoodsId
                                     , COALESCE (MovementItem.Amount)  AS Amount
                                     , tmpMIPromo.Price                AS PriceSIP
                                     , tmpMIPromo.isChecked
                                     , tmpMIPromo.isReport
                                FROM Movement 
                                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id 
                                  
                                   INNER JOIN tmpMIPromo ON tmpMIPromo.GoodsId = MovementItem.ObjectId
                                                        AND Movement.OperDate >= StartDate_Promo
                                                        AND Movement.OperDate <= EndDate_Promo
                                WHERE Movement.DescId = zc_Movement_Income()
                                  AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                  AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate 
                                --AND Movement.OperDate >= '01.01.2018'/*inStartDate*/ AND Movement.OperDate < '20.02.2018' /*inEndDate */
                                  AND COALESCE (inMakerId,0) <> 0
                                           )
          --
  , tmpMI_Float AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovMIComplete_All.MovementItemId FROM tmpMovMIComplete_All 
                                                              UNION
                                                              SELECT DISTINCT tmpMovMI_UnComplete_All.MovementItemId FROM tmpMovMI_UnComplete_All)
                   )
  , tmpMovMIComplete AS (SELECT Movement.MovementId 
                                , Movement.DescId
                                , Movement.StatusId
                                , Movement.OperDate
                                , Movement.InvNumber
                                , Movement.MovementItemId
                                , Movement.GoodsId
                                , MIFloat_Price.ValueData                 ::TFloat    AS Price  
                                , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat    AS PriceSale
                                , Movement.PriceSIP                                   AS PriceSIP
                                , COALESCE (MIFloat_AmountManual.ValueData, Movement.Amount)  AS Amount
                                , Movement.isChecked
                                , Movement.isReport
                           FROM tmpMovMIComplete_All AS Movement 
                              LEFT JOIN tmpMI_Float AS MIFloat_AmountManual
                                                    ON MIFloat_AmountManual.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                  
                              LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()

                              LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                                    ON MIFloat_PriceSale.MovementItemId = Movement.MovementItemId
                                                   AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                         )

  , tmpMovMI_UnComplete AS (SELECT Movement.MovementId 
                                 , Movement.DescId
                                 , Movement.StatusId
                                 , Movement.OperDate
                                 , Movement.InvNumber
                                 , Movement.MovementItemId
                                 , Movement.GoodsId
                                 , MIFloat_Price.ValueData                 ::TFloat  AS Price  
                                 , COALESCE (MIFloat_PriceSale.ValueData,0)::TFloat  AS PriceSale
                                 , Movement.PriceSIP                                 AS PriceSIP
                                 , COALESCE (MIFloat_AmountManual.ValueData, Movement.Amount)  AS Amount
                                 , Movement.isChecked
                                 , Movement.isReport
                            FROM tmpMovMI_UnComplete_All AS Movement 
                               LEFT JOIN tmpMI_Float AS MIFloat_AmountManual
                                                     ON MIFloat_AmountManual.MovementItemId = Movement.MovementItemId
                                                    AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                   
                               LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                           ON MIFloat_Price.MovementItemId = Movement.MovementItemId
                                                          AND MIFloat_Price.DescId = zc_MIFloat_Price()

                               LEFT JOIN tmpMI_Float AS MIFloat_PriceSale
                                                           ON MIFloat_PriceSale.MovementItemId = Movement.MovementItemId
                                                          AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                            )

  , tmpMovMI AS (SELECT tmpMovMIComplete.MovementId
                      , tmpMovMIComplete.DescId
                      , tmpMovMIComplete.StatusId
                      , tmpMovMIComplete.OperDate
                      , tmpMovMIComplete.InvNumber
                      , tmpMovMIComplete.MovementItemId
                      , tmpMovMIComplete.GoodsId
                      , tmpMovMIComplete.Price  
                      , tmpMovMIComplete.PriceSale
                      , tmpMovMIComplete.PriceSIP
                      , tmpMovMIComplete.Amount
                      , tmpMovMIComplete.isChecked
                      , tmpMovMIComplete.isReport
                 FROM tmpMovMIComplete
               UNION 
                 SELECT tmpMovMI_UnComplete.MovementId
                      , tmpMovMI_UnComplete.DescId
                      , tmpMovMI_UnComplete.StatusId
                      , tmpMovMI_UnComplete.OperDate
                      , tmpMovMI_UnComplete.InvNumber
                      , tmpMovMI_UnComplete.MovementItemId
                      , tmpMovMI_UnComplete.GoodsId
                      , tmpMovMI_UnComplete.Price  
                      , tmpMovMI_UnComplete.PriceSale
                      , tmpMovMI_UnComplete.PriceSIP
                      , tmpMovMI_UnComplete.Amount
                      , tmpMovMI_UnComplete.isChecked
                      , tmpMovMI_UnComplete.isReport
                 FROM tmpMovMI_UnComplete
              )

  , tmpMovementDate AS (SELECT MovementDate.*
                        FROM MovementDate
                        WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementString AS (SELECT MovementString.*
                        FROM MovementString
                        WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementBoolean AS (SELECT MovementBoolean.*
                        FROM MovementBoolean
                        WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
  , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                        FROM MovementLinkObject
                        WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovMI.MovementId FROM tmpMovMI)
                       )
   
  -- получаем свойства Документов
  , tmpMov AS (SELECT  tmpMovMI.MovementId           
                     , Object_Unit.ID                           AS UnitId
                     , Object_Unit.ValueData                    AS UnitName
                     , Object_MainJuridical.Id                  AS MainJuridicalId
                     , Object_MainJuridical.ValueData           AS MainJuridicalName
                     , Object_From.Id                           AS JuridicalId
                     , Object_From.ValueData                    AS JuridicalName
                     , Object_Retail.ValueData                  AS RetailName 
                     , MovementDate_Payment.ValueData           AS PaymentDate
                     , MovementString_InvNumberBranch.ValueData AS InvNumberBranch
                     , MovementDate_Branch.ValueData            AS BranchDate
                     , MovementDate_Insert.ValueData            AS InsertDate
                     , COALESCE(MovementBoolean_PriceWithVAT.ValueData,False)  AS PriceWithVAT
                     , ObjectFloat_NDSKind_NDS.ValueData AS NDS
           
                     , MovementDesc.ItemName        :: TVarChar AS ItemName
                     , Status.ValueData                         AS STatusName
               FROM (SELECT DISTINCT tmpMovMI.MovementId, tmpMovMI.StatusId, tmpMovMI.DescId
                     FROM tmpMovMI
                     ) AS tmpMovMI 
                       LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                 ON MovementDate_Insert.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                       LEFT JOIN tmpMovementDate AS MovementDate_Payment
                                                 ON MovementDate_Payment.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Payment.DescId = zc_MovementDate_Payment()
                       LEFT JOIN tmpMovementDate AS MovementDate_Branch
                                                 ON MovementDate_Branch.MovementId = tmpMovMI.MovementId
                                                AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
       
                       LEFT JOIN tmpMovementString AS MovementString_InvNumberBranch
                                                   ON MovementString_InvNumberBranch.MovementId = tmpMovMI.MovementId
                                                  AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                       LEFT JOIN tmpMovementBoolean AS MovementBoolean_PriceWithVAT
                                                    ON MovementBoolean_PriceWithVAT.MovementId = tmpMovMI.MovementId
                                                   AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_NDSKind
                                                       ON MovementLinkObject_NDSKind.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                       LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                             ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                            AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS() 

                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                       ON MovementLinkObject_Unit.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                       LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = tmpMovMI.MovementId
                                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

                       LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId   
                       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(MovementLinkObject_Unit.ObjectId, MovementLinkObject_To.ObjectId) 

                       LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                            ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                           AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       LEFT JOIN Object AS Object_MainJuridical ON Object_MainJuridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

                       LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                            ON ObjectLink_Juridical_Retail.ObjectId = Object_MainJuridical.Id
                                           AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                       LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                       LEFT JOIN Object AS Status ON Status.Id = tmpMovMI.StatusId 
                       LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovMI.DescId
               )



  , tmpMovementItemLinkObject AS (SELECT MovementItemLinkObject.*
                                       , ObjectString_Goods_Maker.ValueData       AS MakerName
                                  FROM MovementItemLinkObject
                                       LEFT JOIN ObjectString AS ObjectString_Goods_Maker
                                           ON ObjectString_Goods_Maker.ObjectId = MovementItemLinkObject.ObjectId
                                          AND ObjectString_Goods_Maker.DescId = zc_ObjectString_Goods_Maker() and 1=0
                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_Goods()
             
                                 )

  , tmpMovementItemDate AS (SELECT MovementItemDate.*
                            FROM MovementItemDate
                            WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                              AND MovementItemDate.DescId = zc_MIDate_PartionGoods() 
                           )
  , tmpMovementItemString AS (SELECT MovementItemString.*
                              FROM MovementItemString
                              WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMovMI.MovementItemId FROM tmpMovMI)
                                AND MovementItemString.DescId = zc_MIString_PartionGoods()
                             )
  , tmpNDSKind AS (SELECT ObjectLink.*
                   FROM ObjectLink
                   WHERE ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind()
                     AND ObjectLink.ObjectId IN (SELECT DISTINCT tmpMovMI.GoodsId FROM tmpMovMI)
                  )
  , tmpGoods AS (SELECT tmp.GoodsId
                      , Object.ObjectCode                        AS Code
                      , Object.ValueData                         AS Name
                      , Object_NDSKind.ValueData                 AS NDSKindName
                      , ObjectFloat_NDSKind_NDS.ValueData        AS NDS
                      , Object_Goods_Main.MorionCode             AS MorionCode
                 FROM (SELECT DISTINCT tmpMovMI.GoodsId FROM tmpMovMI) AS tmp
                      LEFT JOIN Object ON Object.Id = tmp.GoodsId
  
                      LEFT JOIN tmpNDSKind AS ObjectLink_Goods_NDSKind
                                           ON ObjectLink_Goods_NDSKind.ObjectId = Object.Id
                                          
                      LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
              
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                      LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = Object.Id
                      LEFT JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                 )
  , tmpMakerReport AS (SELECT DISTINCT ObjectLink_Juridical.ChildObjectId AS JuridicalId
                       FROM Object AS Object_MakerReport
   
                            LEFT JOIN ObjectLink AS ObjectLink_Maker 
                                ON ObjectLink_Maker.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Maker.DescId = zc_ObjectLink_MakerReport_Maker()

                            INNER JOIN ObjectLink AS ObjectLink_Juridical 
                                ON ObjectLink_Juridical.ObjectId = Object_MakerReport.Id 
                               AND ObjectLink_Juridical.DescId = zc_ObjectLink_MakerReport_Juridical()

                       WHERE Object_MakerReport.DescId = zc_Object_MakerReport()
                         AND COALESCE (ObjectLink_Maker.ChildObjectid, inMakerId) = inMakerId
                         AND Object_MakerReport.isErased = False
                       )

      -- результат
      SELECT  tmpMovMI.MovementId
            , tmpMov.ItemName        :: TVarChar
            , tmpMov.STatusName
            , tmpMovMI.Amount        :: Tfloat
            , tmpGoods.Code
            , tmpGoods.Name
            , Object_PartnerGoods.ValueData      AS PartnerGoodsName
            , MILinkObject_Goods.MakerName
            , tmpGoods.NDSKindName
            , tmpGoods.NDS
            , tmpGoods.MorionCode

            , tmpMovMI.OperDate
            , tmpMovMI.InvNumber
            , tmpMov.UnitID
            , tmpMov.UnitName
            , tmpMov.MainJuridicalId
            , tmpMov.MainJuridicalName
            , tmpMov.JuridicalId
            , tmpMov.JuridicalName
            , tmpMov.RetailName 
            , tmpMovMI.Price
            , Round(tmpMovMI.Amount * tmpMovMI.Price, 2) ::TFloat  AS Summa
            , CASE WHEN COALESCE(tmpMov.PriceWithVAT,False) = TRUE THEN tmpMovMI.Price
                   ELSE (tmpMovMI.Price * (1 + tmpMov.NDS /100))::TFloat
              END AS PriceWithVAT
            , Round(tmpMovMI.Amount * CASE WHEN COALESCE(tmpMov.PriceWithVAT,False) = TRUE THEN tmpMovMI.Price
                                           ELSE (tmpMovMI.Price * (1 + tmpMov.NDS /100))::TFloat
                                      END, 2) ::TFloat  AS SummaWithVAT

            , tmpMovMI.PriceSale  
            
            , tmpMovMI.PriceSIP
            , Round(tmpMovMI.Amount * tmpMovMI.PriceSIP, 2) ::TFloat  AS SummSIP
            
            , COALESCE (MIString_PartionGoods.ValueData, '')             :: TVarChar  AS PartionGoods
            , COALESCE (MIDate_ExpirationDate.ValueData, zc_DateStart()) :: TDateTime AS ExpirationDate
         
            , tmpMov.PaymentDate
            , tmpMov.InvNumberBranch
            , tmpMov.BranchDate
            , tmpMov.InsertDate
            
            , tmpMovMI.isChecked
            , tmpMovMI.isReport
            , CASE WHEN COALESCE(MakerReport.JuridicalId, 0) = 0 THEN True ELSE False END  AS isSendMaker  
            , Object_GoodsGroupPromo.ValueData       AS GoodsGroupPromoName
            
      FROM tmpMovMI 
           LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmpMovMI.GoodsId
    
           LEFT JOIN tmpMov ON tmpMov.MovementId = tmpMovMI.MovementId
   
           LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Goods
                                               ON MILinkObject_Goods.MovementItemId = tmpMovMI.MovementItemId
           LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = MILinkObject_Goods.ObjectId  

           LEFT JOIN tmpMovementItemDate AS MIDate_ExpirationDate
                                         ON MIDate_ExpirationDate.MovementItemId = tmpMovMI.MovementItemId
     
           LEFT JOIN tmpMovementItemString AS MIString_PartionGoods
                                           ON MIString_PartionGoods.MovementItemId = tmpMovMI.MovementItemId

          LEFT JOIN tmpMakerReport AS MakerReport
                                   ON MakerReport.JuridicalId = MILinkObject_Goods.ObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupPromo 
                               ON ObjectLink_Goods_GoodsGroupPromo.ObjectId = tmpMovMI.GoodsId
                              AND ObjectLink_Goods_GoodsGroupPromo.DescId = zc_ObjectLink_Goods_GoodsGroupPromo()
          LEFT JOIN Object AS Object_GoodsGroupPromo ON Object_GoodsGroupPromo.Id = ObjectLink_Goods_GoodsGroupPromo.ChildObjectId
;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В. 
 18.04.19                                                                                    *
 01.02.19                                                      *
 27.01.19                                                                                    *
 17.01.19                                                                                    *
 20.02.18         *
 07.11.16         *
*/

-- тест
-- SELECT * FROM gpReport_MovementIncome_Promo_22 (inMakerId:= 2336655, inStartDate:= '21.11.2016', inEndDate:= '25.11.2016', inSession:= '2')
--SELECT * FROM gpReport_MovementIncome_Promo_22 (inMakerId:= 2336655, inStartDate:= '01.12.2016', inEndDate:= '03.12.2016', inSession:= '2')
--select * from gpReport_MovementIncome_Promo(inMakerId := 6145049  , inStartDate := ('01.12.2018')::TDateTime , inEndDate := ('01.01.2019')::TDateTime ,  inSession := '3'::TVarChar);

select * from gpReport_MovementIncome_Promo(inMakerId := 15451717 , inStartDate := ('01.12.2021')::TDateTime , inEndDate := ('11.01.2022')::TDateTime ,  inSession := '3');
