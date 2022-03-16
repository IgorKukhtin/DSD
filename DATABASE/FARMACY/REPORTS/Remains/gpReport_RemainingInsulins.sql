 -- Function: gpReport_RemainingInsulins()

DROP FUNCTION IF EXISTS gpReport_RemainingInsulins (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_RemainingInsulins(
    IN inOperDate            TDateTime,  -- Дата начала
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord Integer, JuridicalId  Integer, JuridicalName  TVarChar
             , UnitId Integer, UnitName TVarChar, Address TVarChar
             , License TVarChar, MainName_Cut TVarChar, TimeWork TVarChar, OpennessStatus TVarChar

             , GoodsCode Integer, GoodsName TVarChar
             , Remaining TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    -- Ограничение на просмотр товарного справочника
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    -- Результат
    RETURN QUERY
        WITH   
        
           tmpMedicalProgramSPUnit AS (SELECT ObjectLink_MedicalProgramSP.ChildObjectId         AS MedicalProgramSPId
                                            , ObjectLink_Unit.ChildObjectId                     AS UnitId 
                                       FROM Object AS Object_MedicalProgramSPLink
                                            INNER JOIN ObjectLink AS ObjectLink_MedicalProgramSP
                                                                  ON ObjectLink_MedicalProgramSP.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_MedicalProgramSP.DescId = zc_ObjectLink_MedicalProgramSPLink_MedicalProgramSP()
                                            INNER JOIN ObjectLink AS ObjectLink_Unit
                                                                  ON ObjectLink_Unit.ObjectId = Object_MedicalProgramSPLink.Id
                                                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_MedicalProgramSPLink_Unit()
                                        WHERE Object_MedicalProgramSPLink.DescId = zc_Object_MedicalProgramSPLink()
                                          AND Object_MedicalProgramSPLink.isErased = False
                                          AND ObjectLink_MedicalProgramSP.ChildObjectId IN (18078185, 18078194, 18078210, 18078197, 18078175)),
           tmpGoodsSP AS (SELECT DISTINCT
                                 tmpMedicalProgramSPUnit.UnitId  AS UnitId
                               , Object_Goods_Retail.Id          AS GoodsId
                          FROM Movement
                               INNER JOIN MovementDate AS MovementDate_OperDateStart
                                                       ON MovementDate_OperDateStart.MovementId = Movement.Id
                                                      AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                                      AND MovementDate_OperDateStart.ValueData  <= CURRENT_DATE

                               INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                                       ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                                      AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                                      AND MovementDate_OperDateEnd.ValueData  >= CURRENT_DATE
                               INNER JOIN MovementLinkObject AS MLO_MedicalProgramSP
                                                             ON MLO_MedicalProgramSP.MovementId = Movement.Id
                                                            AND MLO_MedicalProgramSP.DescId = zc_MovementLink_MedicalProgramSP()
                               INNER JOIN tmpMedicalProgramSPUnit ON tmpMedicalProgramSPUnit.MedicalProgramSPId = MLO_MedicalProgramSP.ObjectId

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                            AND Object_Goods_Retail.RetailId = vbObjectId

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         ),
           tmpContainer AS (SELECT Container.Id  
                                 , Container.ObjectID          AS GoodsId
                                 , Container.WhereObjectId     AS UnitId
                                 , Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) AS Amount
                            FROM tmpGoodsSP

                                 INNER JOIN Container ON Container.ObjectId = tmpGoodsSP.GoodsId
                                                     AND Container.WhereObjectId = tmpGoodsSP.UnitId

                                 LEFT JOIN MovementItemContainer AS MIContainer 
                                                                 ON MIContainer.ContainerId = Container.Id
                                                                AND MIContainer.OperDate >= inOperDate
                            WHERE Container.DescId = zc_Container_count()
                            GROUP BY Container.Id  
                                   , Container.Amount 
                                   , Container.ObjectId
                                   , Container.WhereObjectId 
                            HAVING Container.Amount - COALESCE (SUM (MIContainer.Amount), 0) <> 0),
           tmpData AS (SELECT Container.GoodsId
                            , Container.UnitId
                            , Sum(Container.Amount)       AS Amount
                         FROM tmpContainer AS Container
                         GROUP BY Container.GoodsId
                                , Container.UnitId
                         ),
           tmpObjectHistory AS (SELECT *
                                FROM ObjectHistory
                                WHERE ObjectHistory.DescId = zc_ObjectHistory_JuridicalDetails()
                                  AND ObjectHistory.enddate::timestamp with time zone = zc_dateend()::timestamp with time zone
                                ),
           tmpJuridicalDetails AS (SELECT ObjectHistory_JuridicalDetails.ObjectId                                        AS JuridicalId
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

        -- Результат
        SELECT ROW_NUMBER() OVER (ORDER BY Object_Juridical.ValueData
                                         , Object_Unit.ValueData
                                         , COALESCE(Object_Goods_Main.NameUkr, Object_Goods_Main.Name))::Integer AS Ord
             , Object_Juridical.Id                                   AS JuridicalId
             , Object_Juridical.ValueData                            AS JuridicalName
             , Object_Unit.Id                                        AS UnitId
             , Object_Unit.ValueData                                 AS UnitName
             , ObjectString_Unit_Address.ValueData                   AS Address
             , tmpJuridicalDetails.License
             , tmpJuridicalDetails.MainName_Cut
             , (CASE WHEN COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_MondayStart.ValueData ::Time,'00:00') <> '00:00'
                     THEN 'Пн-Пт '||LEFT ((ObjectDate_MondayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_MondayEnd.ValueData::Time)::TVarChar,5)||'; '
                     ELSE ''
                END||'' ||
                CASE WHEN COALESCE(ObjectDate_SaturdayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SaturdayEnd.ValueData ::Time,'00:00') <> '00:00'
                     THEN 'Сб '||LEFT ((ObjectDate_SaturdayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SaturdayEnd.ValueData::Time)::TVarChar,5)||'; '
                     ELSE ''
                END||''||
                CASE WHEN COALESCE(ObjectDate_SundayStart.ValueData ::Time,'00:00') <> '00:00' AND COALESCE(ObjectDate_SundayEnd.ValueData ::Time,'00:00') <> '00:00'
                     THEN 'Нд '||LEFT ((ObjectDate_SundayStart.ValueData::Time)::TVarChar,5)||'-'||LEFT ((ObjectDate_SundayEnd.ValueData::Time)::TVarChar,5)
                     ELSE ''
                END) :: TVarChar AS TimeWork
                
             , 'Працює'::TVarChar AS OpennessStatus
             
             , Object_Goods_Main.ObjectCode                          AS GoodsCode
             , COALESCE(Object_Goods_Main.NameUkr, Object_Goods_Main.Name) AS GoodsName
             
             , tmpData.Amount ::TFloat                               AS Amount
             
        FROM tmpData

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpData.UnitId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = tmpData.UnitId
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

             LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = tmpData.GoodsId
             LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
             
             LEFT JOIN ObjectString AS ObjectString_Unit_Address
                                    ON ObjectString_Unit_Address.ObjectId = Object_Unit.Id
                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()   
                                             
             LEFT JOIN ObjectDate AS ObjectDate_MondayStart
                                  ON ObjectDate_MondayStart.ObjectId = Object_Unit.Id
                                 AND ObjectDate_MondayStart.DescId = zc_ObjectDate_Unit_MondayStart()
             LEFT JOIN ObjectDate AS ObjectDate_MondayEnd
                                  ON ObjectDate_MondayEnd.ObjectId = Object_Unit.Id
                                 AND ObjectDate_MondayEnd.DescId = zc_ObjectDate_Unit_MondayEnd()
             LEFT JOIN ObjectDate AS ObjectDate_SaturdayStart
                                  ON ObjectDate_SaturdayStart.ObjectId = Object_Unit.Id
                                 AND ObjectDate_SaturdayStart.DescId = zc_ObjectDate_Unit_SaturdayStart()
             LEFT JOIN ObjectDate AS ObjectDate_SaturdayEnd
                                  ON ObjectDate_SaturdayEnd.ObjectId = Object_Unit.Id
                                 AND ObjectDate_SaturdayEnd.DescId = zc_ObjectDate_Unit_SaturdayEnd()
             LEFT JOIN ObjectDate AS ObjectDate_SundayStart
                                  ON ObjectDate_SundayStart.ObjectId = Object_Unit.Id
                                 AND ObjectDate_SundayStart.DescId = zc_ObjectDate_Unit_SundayStart()
             LEFT JOIN ObjectDate AS ObjectDate_SundayEnd 
                                  ON ObjectDate_SundayEnd.ObjectId = Object_Unit.Id
                                 AND ObjectDate_SundayEnd.DescId = zc_ObjectDate_Unit_SundayEnd()
             LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                  ON ObjectDate_FirstCheck.ObjectId = Object_Unit.Id
                                 AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()
                                 
             LEFT JOIN tmpJuridicalDetails ON tmpJuridicalDetails.JuridicalId = Object_Juridical.Id

        ORDER BY Object_Juridical.ValueData
               , Object_Unit.ValueData
               , COALESCE(Object_Goods_Main.NameUkr, Object_Goods_Main.Name)

         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.03.22                                                       *
*/

-- тест
--
select * from gpReport_RemainingInsulins (inOperDate := ('17.03.2022')::TDateTime, inSession := '3');