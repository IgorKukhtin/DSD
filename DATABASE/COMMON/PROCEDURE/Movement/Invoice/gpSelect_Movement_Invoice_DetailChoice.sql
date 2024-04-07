-- Function: gpSelect_Movement_Invoice_DetailChoice()

DROP FUNCTION IF EXISTS gpSelect_Movement_Invoice_DetailChoice (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Invoice_DetailChoice (
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inJuridicalId   Integer  ,
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementDesc TVarChar, InvNumber TVarChar, InvNumber_Full TVarChar
             , InvNumberPartner TVarChar
             , OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , InsertDate TDateTime, InsertName TVarChar
             , PriceWithVAT Boolean, VATPercent TFloat, ChangePercent TFloat
             , CurrencyValue TFloat, TotalSumm TFloat
             , CurrencyDocumentId Integer, CurrencyDocumentName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , Comment TVarChar
             , isClosed Boolean
               --
             , MovementItemId Integer, MovementId_OrderIncome Integer, InvNumber_OrderIncome TVarChar
             , Amount TFloat, Price TFloat, CountForPrice TFloat, AmountSumm TFloat
             , MIComment TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, InvNumber_Asset TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , NameBeforeId Integer, NameBeforeCode Integer, NameBeforeName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , AssetId Integer, AssetName TVarChar
             , isErased Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Invoice());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);


     -- проверка
     IF inStartDate < inEndDate - INTERVAL '1 YEAR' AND COALESCE (inJuridicalId, 0) = 0
     THEN
         -- RAISE EXCEPTION 'Ошибка.Выбранный период с <%> по <%> больше 1 года.Необходимо установить меньше период.', zfConvert_DateToString (inStartDate), zfConvert_DateToString (inEndDate);
         inStartDate:= inEndDate - INTERVAL '6 MONTH';
     END IF;



     IF COALESCE (inJuridicalId,0) <>0 THEN
         inJuridicalId:= (SELECT CASE WHEN Object.DescId <> zc_Object_Juridical() THEN ObjectLink_Partner_Juridical.ChildObjectId ELSE inJuridicalId END
                          FROM Object
                              LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                ON ObjectLink_Partner_Juridical.ObjectId = Object.Id
                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                          WHERE Object.Id = inJuridicalId);
     END IF;


     -- Результат
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpUserAdmin AS (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId)

        , tmpMovement AS (SELECT Movement.id
                               , MovementLinkObject_Juridical.ObjectId     AS JuridicalId
                               , COALESCE (MovementBoolean_Closed.ValueData, FALSE) :: Boolean AS isClosed
                          FROM tmpStatus
                             INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                AND Movement.DescId = zc_Movement_Invoice()
                                                AND Movement.StatusId = tmpStatus.StatusId
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                           ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                                          AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                                          AND (MovementLinkObject_Juridical.ObjectId = inJuridicalId OR inJuridicalId = 0)
                             LEFT JOIN MovementBoolean AS MovementBoolean_Closed
                                                       ON MovementBoolean_Closed.MovementId = Movement.Id
                                                      AND MovementBoolean_Closed.DescId = zc_MovementBoolean_Closed()
                          )

     , tmpMI AS (SELECT MovementItem.Id
                      , MovementItem.MovementId
                      , MovementItem.ObjectId  AS MeasureId
                      , MovementItem.Amount
                      , MovementItem.isErased
                      , CASE WHEN Movement_OrderIncome.StatusId <> zc_Enum_Status_Erased() THEN MI_OrderIncome.Id         ELSE 0 END AS MIId_OrderIncome
                      , CASE WHEN Movement_OrderIncome.StatusId <> zc_Enum_Status_Erased() THEN MI_OrderIncome.MovementId ELSE 0 END AS MovementId_OrderIncome
                      , zfCalc_PartionMovementName (Movement_OrderIncome.DescId, MovementDesc.ItemName, Movement_OrderIncome.InvNumber, Movement_OrderIncome.OperDate) AS InvNumber_OrderIncome
                 FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                    LEFT JOIN tmpMovement ON 1=1
                    INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                           AND MovementItem.DescId     = zc_MI_Master()
                                           AND MovementItem.isErased   = tmpIsErased.isErased
                    -- это док. "заявка поставщику"
                    LEFT JOIN MovementItemFloat AS MIFloat_OrderIncome
                                                ON MIFloat_OrderIncome.MovementItemId = MovementItem.Id
                                               AND MIFloat_OrderIncome.DescId = zc_MIFloat_MovementItemId()
                    LEFT JOIN MovementItem AS MI_OrderIncome
                                           ON MI_OrderIncome.Id = MIFloat_OrderIncome.ValueData :: Integer
                                          AND MI_OrderIncome.isErased = FALSE
                    LEFT JOIN Movement AS Movement_OrderIncome ON Movement_OrderIncome.Id = MI_OrderIncome.MovementId
                    LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_OrderIncome.DescId
                 )

     , tmpPromoInvoice AS (SELECT Movement.id
                                , Movement.ParentId
                                , Movement.OperDate
                                , Movement.Invnumber 
                                , ('№ ' || Movement.InvNumber || ' от ' || zfConvert_DateToString (Movement.OperDate)  ) :: TVarChar AS InvNumberFull
                                , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
                                , Movement_parent.InvNumber              AS InvNumber_Parent

                                , Object_Status.Id                       AS StatusId
                                , Object_Status.ObjectCode               AS StatusCode         --код статуса
                                , Object_Status.ValueData                AS StatusName         --Статус

                                , Object_BonusKind.Id                    AS BonusKindId
                                , Object_BonusKind.ValueData             AS BonusKindName

                                , Object_PaidKind.Id                     AS PaidKindId
                                , Object_PaidKind.ValueData              AS PaidKindName

                                , MovementFloat_TotalSumm.ValueData      AS TotalSumm
                                , MovementString_Comment.ValueData       AS Comment
                                , Object_Insert.ValueData             AS InsertName
                                , MovementDate_Insert.ValueData       AS InsertDate
                           FROM tmpStatus
                              INNER JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                 AND Movement.DescId = zc_Movement_PromoInvoice()
                                                 AND Movement.StatusId = tmpStatus.StatusId
                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_BonusKind
                                                           ON MovementLinkObject_BonusKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_BonusKind.DescId = zc_MovementLinkObject_BonusKind()
                              LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MovementLinkObject_BonusKind.ObjectId
                      
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                           ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                                          AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                              LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId
                      
                              LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                       ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                                      AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                      
                              LEFT JOIN MovementString AS MovementString_Comment
                                                       ON MovementString_Comment.MovementId = Movement.Id
                                                      AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                                            
                              LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                              LEFT JOIN Movement AS Movement_parent ON Movement_parent.Id = Movement.ParentId

                              LEFT JOIN MovementDate AS MovementDate_Insert
                                                     ON MovementDate_Insert.MovementId = Movement.Id
                                                    AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                           ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                          AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
                              LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId
                           )

     , tmpPromoInv_partner AS (SELECT tmpPromoInvoice.*
                                    , MovementLinkObject_Partner.ObjectId    AS PartnerId               --Покупатель для акции
                                    , Object_Partner.ObjectCode              AS PartnerCode             --Покупатель для акции
                                    , Object_Partner.ValueData               AS PartnerName             --Покупатель для акции
                                    , Object_Partner.DescId                  AS PartnerDescId           --Тип Покупатель для акции
                                    , ObjectDesc_Partner.ItemName            AS PartnerDescName         --Тип Покупатель для акции
                                    , Object_Juridical.Id                    AS JuridicalId
                                    , Object_Juridical.ValueData             AS JuridicalName
                                    , Object_Retail.ValueData                AS Retail_Name
                                    , Object_Contract.Id                     AS ContractId
                                    , Object_Contract.ObjectCode             AS ContractCode
                                    , Object_Contract.ValueData              AS ContractName
                                    
                               FROM tmpPromoInvoice
                                   INNER JOIN Movement AS Movement_Partner ON Movement_Partner.ParentId = tmpPromoInvoice.ParentId
                                                      AND Movement_Partner.DescId = zc_Movement_PromoPartner()
                                                      AND Movement_Partner.StatusId <> zc_Enum_Status_Erased()

                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                ON MovementLinkObject_Partner.MovementId = Movement_Partner.Id
                                                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                   LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                                   LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId
                           
                                   LEFT OUTER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                              ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                                             AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                                             AND Object_Partner.DescId = zc_Object_Partner()
                                   LEFT OUTER JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Partner_Juridical.ChildObjectId
                           
                                   LEFT OUTER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                              ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, Object_Partner.Id)
                                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                   LEFT OUTER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                           
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                ON MovementLinkObject_Contract.MovementId = Movement_Partner.Id
                                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                   LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                              )


      -- Результат
      SELECT Movement.Id                            AS Id
           , 'Счет'::TVarChar                       AS MovementDesc
           , Movement.InvNumber                     AS InvNumber
           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName,  COALESCE(MovementString_InvNumberPartner.ValueData,'')||'/'||Movement.InvNumber, Movement.OperDate) AS InvNumber_Full
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
           , Movement.OperDate                      AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , MovementDate_Insert.ValueData          AS InsertDate
           , Object_Insert.ValueData                AS InsertName

           , MovementBoolean_PriceWithVAT.ValueData AS PriceWithVAT
           , MovementFloat_VATPercent.ValueData     AS VATPercent
           , MovementFloat_ChangePercent.ValueData  AS ChangePercent
           , MovementFloat_CurrencyValue.ValueData  AS CurrencyValue
           , MovementFloat_TotalSumm.ValueData      AS TotalSumm

           , Object_CurrencyDocument.Id             AS CurrencyDocumentId
           , Object_CurrencyDocument.ValueData      AS CurrencyDocumentName

           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName

           , Object_Contract.Id                     AS ContractId
           , Object_Contract.ObjectCode             AS ContractCode
           , Object_Contract.ValueData              AS ContractName

           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , MovementString_Comment.ValueData       AS Comment
           , tmpMovement.isClosed

           --строчная часть
           , tmpMI.Id                               AS MovementItemId
           , tmpMI.MovementId_OrderIncome
           , tmpMI.InvNumber_OrderIncome
           , tmpMI.Amount                 :: TFloat AS Amount
           , COALESCE(MIFloat_Price.ValueData,0)            :: TFloat AS Price
           , COALESCE(MIFloat_CountForPrice.ValueData, 1)   :: TFloat AS CountForPrice
           , CASE WHEN COALESCE(MIFloat_CountForPrice.ValueData, 1) > 0
                  THEN CAST (tmpMI.Amount * COALESCE(MIFloat_Price.ValueData,0) / COALESCE(MIFloat_CountForPrice.ValueData, 1) AS NUMERIC (16, 2))
                  ELSE CAST (tmpMI.Amount * COALESCE(MIFloat_Price.ValueData,0) AS NUMERIC (16, 2))
             END :: TFloat AS AmountSumm

           , MIString_Comment.ValueData        :: TVarChar AS MIComment

           , Object_Goods.Id                     AS GoodsId
           , Object_Goods.ObjectCode             AS GoodsCode
           , Object_Goods.ValueData              AS GoodsName
           , ObjectString_InvNumber.ValueData    AS InvNumber_Asset

           , Object_Measure.Id                   AS MeasureId
           , Object_Measure.ValueData            AS MeasureName

           , Object_NameBefore.Id                AS NameBeforeId
           , CASE WHEN Object_NameBefore.ValueData <> '' THEN Object_NameBefore.ObjectCode ELSE Object_Goods.ObjectCode END :: Integer  AS NameBeforeCode
           , CASE WHEN Object_NameBefore.ValueData <> '' THEN Object_NameBefore.ValueData  ELSE Object_Goods.ValueData  END :: TVarChar AS NameBeforeName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ObjectCode              AS UnitCode
           , Object_Unit.ValueData               AS UnitName
           , Object_Asset.Id                     AS AssetId
           , Object_Asset.ValueData              AS AssetName

           , tmpMI.isErased

       FROM tmpMovement
            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMovement.JuridicalId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId =  Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                      ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                     AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
            LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                    ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                   AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()
            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()
            LEFT JOIN MovementFloat AS MovementFloat_CurrencyValue
                                    ON MovementFloat_CurrencyValue.MovementId =  Movement.Id
                                   AND MovementFloat_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                         ON MovementLinkObject_Contract.MovementId = Movement.Id
                                        AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                         ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
            LEFT JOIN Object AS Object_CurrencyDocument ON Object_CurrencyDocument.Id = MovementLinkObject_CurrencyDocument.ObjectId

            -- строчная часть
            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpMI.MeasureId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = tmpMI.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = tmpMI.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId =  tmpMI.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_NameBefore
                                             ON MILinkObject_NameBefore.MovementItemId = tmpMI.Id
                                            AND MILinkObject_NameBefore.DescId = zc_MILinkObject_NameBefore()
            LEFT JOIN Object AS Object_NameBefore ON Object_NameBefore.Id = MILinkObject_NameBefore.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                             ON MILinkObject_Goods.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MILinkObject_Goods.ObjectId
            LEFT JOIN ObjectString AS ObjectString_InvNumber
                                   ON ObjectString_InvNumber.ObjectId = Object_Goods.Id
                                  AND ObjectString_InvNumber.DescId   = zc_ObjectString_Asset_InvNumber()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

    UNION
       SELECT tmp.Id
           , 'Счет для акции'::TVarChar      AS MovementDesc
           , tmp.InvNumber
           , tmp.InvNumberFull AS InvNumber_Full
           , tmp.InvNumberPartner
           , tmp.OperDate
           , tmp.StatusCode
           , tmp.StatusName

           , tmp.InsertDate
           , tmp.InsertName

           , FALSE ::Boolean  AS PriceWithVAT
           , 0 ::TFloat  AS VATPercent
           , 0 ::TFloat  AS ChangePercent
           , 0 ::TFloat  AS CurrencyValue
           , tmp.TotalSumm ::TFloat

           , 0                 AS CurrencyDocumentId
           , ''::TVarChar      AS CurrencyDocumentName

           , tmp.JuridicalId
           , tmp.JuridicalName

           , tmp.ContractId
           , tmp.ContractCode
           , tmp.ContractName

           , tmp.PaidKindId
           , tmp.PaidKindName

           , tmp.Comment :: TVarChar       AS Comment
           , FALSE ::Boolean AS isClosed

           --строчная часть
           , 0                      AS MovementItemId
           , 0        AS MovementId_OrderIncome
           , '' :: TVarChar         AS InvNumber_OrderIncome
           , 0     :: TFloat        AS Amount
           , 0            :: TFloat AS Price
           , 0  :: TFloat           AS CountForPrice
           , 0  :: TFloat           AS AmountSumm

           , '' :: TVarChar         AS MIComment

           , 0                      AS GoodsId
           , 0                      AS GoodsCode
           , '' :: TVarChar              AS GoodsName
           , '' :: TVarChar         AS InvNumber_Asset

           , 0                      AS MeasureId
           , '' :: TVarChar         AS MeasureName

           , 0                      AS NameBeforeId
           , 0  :: Integer          AS NameBeforeCode
           , '' :: TVarChar         AS NameBeforeName
           , 0                      AS UnitId
           , 0                      AS UnitCode
           , '' ::TVarChar          AS UnitName
           , 0                      AS AssetId
           , '' ::TVarChar          AS AssetName

           , CASE WHEN tmp.StatusId = zc_Enum_Status_Erased() THEN TRUE ELSE FALSE END AS isErased
       FROM tmpPromoInv_partner AS tmp
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 06.09.21         *
 21.07.16         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Invoice_DetailChoice (inStartDate:= '04.09.2021', inEndDate:= '06.09.2021', inJuridicalId:= 0, inIsErased := FALSE, inSession:= '2')
