-- Function:  gpReport_Upload_YuriFarm_Income()

DROP FUNCTION IF EXISTS gpReport_Upload_YuriFarm_Income (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpReport_Upload_YuriFarm_Income(
    IN inDate         TDateTime,  -- Операционный день
    IN inUnitID       Integer,    -- Подразделение
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (ID                Integer
             , InvNumber         TVarChar  -- Номер документа
             , OperDate          TDateTime -- Дата - дата операционного дня к которой относится произведенная операция
             , Supplier          TVarChar  -- Поставщик
             , OKPO              TVarChar  -- OKPO

             , MovementItemId    Integer   --
             , id_parsel         Integer   -- ID Партии
             , ExpirationDate    TDateTime -- Срок годности

             , GoodsId           Integer   -- ID товара
             , MorionCode        Integer   -- Код мориона
             , GoodsName         TVarChar  -- Наименование товара - наименование товара в учетной системе компании Клиента
             , GoodsCode         Integer   -- Код товара
             , MakerName         TVarChar  -- Производитель
             , PartionGoods      TVarChar  -- серия

             , NDS               TFloat    -- NDS
             , SummaWithVAT      TFloat    -- Сумма прихода с НДС

             , Amount            TFloat    -- Значение - числовое значение для результата операции. Например, для продажи это кол-во проданных упаковок - 3 шт.

              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
      vbUserId:= lpGetUserBySession (inSession);

      -- список товаров поставщика
      CREATE TEMP TABLE tmpGoods ON COMMIT DROP
      AS (SELECT DISTINCT Object_Goods_Retail.Id        AS GoodsId
                        , Object_Goods_Juridical.ID     AS GoodsJuridicalID
          FROM Object_Goods_Juridical
               JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = Object_Goods_Juridical.GoodsMainId
          WHERE Object_Goods_Juridical.isUploadYuriFarm = True
         );
         
      ANALYSE tmpGoods;

      -- Результат
      RETURN QUERY
        WITH tmpObjectHistory AS (SELECT *
                                  FROM ObjectHistory
                                  WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                    AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                                  )
           , tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
                                          , COALESCE(ObjectHistory_JuridicalDetails.StartDate, zc_DateStart())             AS StartDate
                                          , ObjectHistoryString_JuridicalDetails_FullName.ValueData                        AS FullName
                                          , ObjectHistoryString_JuridicalDetails_JuridicalAddress.ValueData                AS JuridicalAddress
                                          , ObjectHistoryString_JuridicalDetails_OKPO.ValueData                            AS OKPO
                                          , ObjectHistoryString_JuridicalDetails_INN.ValueData                             AS INN
                                          , ObjectHistoryString_JuridicalDetails_NumberVAT.ValueData                       AS NumberVAT
                                          , ObjectHistoryString_JuridicalDetails_AccounterName.ValueData                   AS AccounterName
                                          , ObjectHistoryString_JuridicalDetails_BankAccount.ValueData                     AS BankAccount
                                          , ObjectHistoryString_JuridicalDetails_Phone.ValueData                           AS Phone

                                          , ObjectHistoryString_JuridicalDetails_MainName.ValueData                        AS MainName
                                          , ObjectHistoryString_JuridicalDetails_MainName_Cut.ValueData                    AS MainName_Cut
                                          , ObjectHistoryString_JuridicalDetails_Reestr.ValueData                          AS Reestr
                                          , ObjectHistoryString_JuridicalDetails_Decision.ValueData                        AS Decision
                                          , ObjectHistoryString_JuridicalDetails_License.ValueData                         AS License
                                          , ObjectHistoryDate_JuridicalDetails_Decision.ValueData                          AS DecisionDate

                                     FROM tmpObjectHistory AS ObjectHistory_JuridicalDetails
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_FullName
                                                 ON ObjectHistoryString_JuridicalDetails_FullName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_FullName.DescId = zc_ObjectHistoryString_JuridicalDetails_FullName()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_JuridicalAddress
                                                 ON ObjectHistoryString_JuridicalDetails_JuridicalAddress.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_JuridicalAddress.DescId = zc_ObjectHistoryString_JuridicalDetails_JuridicalAddress()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_OKPO
                                                 ON ObjectHistoryString_JuridicalDetails_OKPO.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_OKPO.DescId = zc_ObjectHistoryString_JuridicalDetails_OKPO()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_INN
                                                 ON ObjectHistoryString_JuridicalDetails_INN.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_INN.DescId = zc_ObjectHistoryString_JuridicalDetails_INN()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_NumberVAT
                                                 ON ObjectHistoryString_JuridicalDetails_NumberVAT.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_NumberVAT.DescId = zc_ObjectHistoryString_JuridicalDetails_NumberVAT()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_AccounterName
                                                 ON ObjectHistoryString_JuridicalDetails_AccounterName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_AccounterName.DescId = zc_ObjectHistoryString_JuridicalDetails_AccounterName()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_BankAccount
                                                 ON ObjectHistoryString_JuridicalDetails_BankAccount.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_BankAccount.DescId = zc_ObjectHistoryString_JuridicalDetails_BankAccount()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Phone
                                                 ON ObjectHistoryString_JuridicalDetails_Phone.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_Phone.DescId = zc_ObjectHistoryString_JuridicalDetails_Phone()

                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName
                                                 ON ObjectHistoryString_JuridicalDetails_MainName.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_MainName.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_MainName_Cut
                                                 ON ObjectHistoryString_JuridicalDetails_MainName_Cut.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_MainName_Cut.DescId = zc_ObjectHistoryString_JuridicalDetails_MainName_Cut()

                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Reestr
                                                 ON ObjectHistoryString_JuridicalDetails_Reestr.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_Reestr.DescId = zc_ObjectHistoryString_JuridicalDetails_Reestr()
                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_Decision
                                                 ON ObjectHistoryString_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_Decision.DescId = zc_ObjectHistoryString_JuridicalDetails_Decision()

                                          LEFT JOIN ObjectHistoryString AS ObjectHistoryString_JuridicalDetails_License
                                                 ON ObjectHistoryString_JuridicalDetails_License.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryString_JuridicalDetails_License.DescId = zc_ObjectHistoryString_JuridicalDetails_License()

                                          LEFT JOIN ObjectHistoryDate AS ObjectHistoryDate_JuridicalDetails_Decision
                                                 ON ObjectHistoryDate_JuridicalDetails_Decision.ObjectHistoryId = ObjectHistory_JuridicalDetails.Id
                                                AND ObjectHistoryDate_JuridicalDetails_Decision.DescId = zc_ObjectHistoryDate_JuridicalDetails_Decision()
                                     )

           , tmpMovement AS (SELECT Movement.Id
                                  , Movement.InvNumber
                                  , MovementItemContainer.OperDate
                                  , Container.ID                        AS ContainerID
                                  , tmpGoods.GoodsId
                                  , tmpGoods.GoodsJuridicalID
                                  , MovementItem.Id                     AS MovementItemId
                                  , MovementItemContainer.Amount        AS Amount
                              FROM MovementItemContainer

                                   JOIN Movement ON Movement.Id = MovementItemContainer.MovementId
                                                AND Movement.StatusId = zc_Enum_Status_Complete()

                                   JOIN Container ON Container.ID = MovementItemContainer.ContainerId
                                                 AND Container.DescId = zc_Container_Count()
                                                 AND Container.WhereObjectId = inUnitID

                                   JOIN tmpGoods ON tmpGoods.GoodsId = Container.ObjectId

                                   JOIN MovementItem ON MovementItem.Id = MovementItemContainer.MovementItemId

                              WHERE MovementItemContainer.OperDate >= DATE_TRUNC ('day', inDate)
                                AND MovementItemContainer.OperDate < DATE_TRUNC ('day', inDate) + interval '1 day'
                                AND MovementItemContainer.MovementDescId = zc_Movement_Income()
                            )
           , tmpContainer AS (SELECT Container.ContainerID
                                   , Object_PartionMovementItem.Id                                   AS id_parsel
                                   , MIDate_ExpirationDate.ValueData                                 AS ExpirationDate
                                   , Container.MovementItemId
                                   , Container.ID
                                   , MIString_PartionGoods.ValueData                                 AS PartionGoods
                                   , MIFloat_PriceWithVAT.ValueData                                  AS PriceWithVAT
                                   , MovementLinkObject_From.ObjectId                                AS JuridicalId
                              FROM tmpMovement AS Container
                                   LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                                 ON ContainerLinkObject_MovementItem.Containerid = Container.ContainerID
                                                                AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                                   LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                                   LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                                    ON MIDate_ExpirationDate.MovementItemId = Container.MovementItemId
                                                                   AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()
                                   -- Серия
                                   LEFT JOIN MovementItemString AS MIString_PartionGoods
                                                                ON MIString_PartionGoods.MovementItemId = Container.MovementItemId
                                                               AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                                ON MovementLinkObject_From.MovementId = Container.ID
                                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                                   LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                               ON MIFloat_PriceWithVAT.MovementItemId = Container.MovementItemId
                                                              AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()
                              )
           ,  tmpNDS AS (SELECT Object_NDSKind.Id
                              , Object_NDSKind.ValueData                        AS NDSKindName
                              , ObjectFloat_NDSKind_NDS.ValueData               AS NDS
                         FROM Object AS Object_NDSKind
                              LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                    ON ObjectFloat_NDSKind_NDS.ObjectId = Object_NDSKind.Id
                                                   AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         WHERE Object_NDSKind.DescId = zc_Object_NDSKind()
                        )


        SELECT Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Object_From.ValueData                              AS Supplier
             , tmpJuridicalDetails.OKPO

             , Movement.MovementItemId
             , tmpContainer.id_parsel
             , tmpContainer.ExpirationDate

             , Movement.GoodsJuridicalId
             , Object_Goods_Main.MorionCode
             , Object_Goods_Juridical.Name                        AS GoodsName
             , Object_Goods_Main.ObjectCode                       AS GoodsCode
             , Object_Goods_Juridical.MakerName                   AS MakerName
             , tmpContainer.PartionGoods

             , tmpNDS.NDS                                         AS NDS

             , Round(tmpContainer.PriceWithVAT * Movement.Amount, 2)::TFloat   AS SummaWithVAT

             , Movement.Amount::TFloat                            AS Amount
        FROM tmpMovement AS Movement

             LEFT JOIN MovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN tmpContainer ON tmpContainer.ContainerID = Movement.ContainerID

             LEFT JOIN  Object_Goods_Juridical ON Object_Goods_Juridical.Id = Movement.GoodsJuridicalID
             LEFT JOIN  Object_Goods_Retail ON Object_Goods_Retail.Id = Movement.GoodsId
             LEFT JOIN  Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

             LEFT JOIN Object AS Object_From ON Object_From.Id = tmpContainer.JuridicalId
             LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = tmpContainer.JuridicalId


             LEFT JOIN tmpNDS ON tmpNDS.Id = Object_Goods_Main.NDSKindId

        ORDER BY Movement.Id;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.11.19                                                       *

*/

-- тест
--
SELECT * FROM gpReport_Upload_YuriFarm_Income (inDate:= '21.11.2019'::TDateTime, inUnitID := 377606, inSession:= zfCalc_UserAdmin())
