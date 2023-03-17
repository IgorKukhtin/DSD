-- Function: gpSelect_GoodsSPReceiptList()

DROP FUNCTION IF EXISTS gpSelect_GoodsSPReceiptList (Integer, Text, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsSPReceiptList(
    IN inMedicalProgramSPId  Integer,    -- Медицинская программа
    IN inMedication_ID_List  Text,       -- Перечень ID медикаментов
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (MedicationID TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIndex Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    -- vbUserId:= lpGetUserBySession (inSession);
    vbUserId:= inSession :: Integer;
    
    -- таблица
    CREATE TEMP TABLE _tmpMedication_ID (MedicationID TVarChar) ON COMMIT DROP;

    -- парсим подразделения
    vbIndex := 1;
    WHILE SPLIT_PART (inMedication_ID_List, ',', vbIndex) <> '' LOOP
        -- добавляем то что нашли
        INSERT INTO _tmpMedication_ID (MedicationID)
           SELECT SPLIT_PART (inMedication_ID_List, ',', vbIndex);
        -- теперь следуюющий
        vbIndex := vbIndex + 1;
    END LOOP;

    RETURN QUERY
      WITH -- Товары соц-проект
           tmpGoodsSP AS (SELECT MovementItem.ObjectId         AS GoodsId
                               , MLO_MedicalProgramSP.ObjectId AS MedicalProgramSPID
                               , MI_IntenalSP.ObjectId         AS IntenalSPId
                               , MIFloat_PriceRetSP.ValueData  AS PriceRetSP
                               , MIFloat_PriceSP.ValueData     AS PriceSP
                               , MIFloat_PaymentSP.ValueData   AS PaymentSP
                               , MIFloat_CountSP.ValueData     AS CountSP
                               , MIFloat_CountSPMin.ValueData  AS CountSPMin
                               , MIString_IdSP.ValueData       AS IdSP
                               , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar AS ProgramIdSP
                               , MIString_DosageIdSP.ValueData AS DosageIdSP
                                                                -- № п/п - на всякий случай
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC) AS Ord
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
                                                            AND MLO_MedicalProgramSP.ObjectId = inMedicalProgramSPId

                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                     AND MovementItem.DescId     = zc_MI_Master()
                                                     AND MovementItem.isErased   = FALSE

                               LEFT JOIN MovementItemLinkObject AS MI_IntenalSP
                                                                ON MI_IntenalSP.MovementItemId = MovementItem.Id
                                                               AND MI_IntenalSP.DescId = zc_MILinkObject_IntenalSP()
                               -- Роздрібна  ціна за упаковку, грн
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                                           ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
                               -- Розмір відшкодування за упаковку (Соц. проект) - (15)
                               LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                                           ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
                               -- Сума доплати за упаковку, грн (Соц. проект) - 16)
                               LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                                           ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                                           ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
                               -- Кількість одиниць лікарського засобу у споживчій упаковці (Соц. проект)(6)
                               LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                                           ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                                          AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
                               -- ID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_IdSP
                                                            ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_IdSP.DescId = zc_MIString_IdSP()
                               LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                            ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()
                               -- DosageID лікарського засобу
                               LEFT JOIN MovementItemString AS MIString_DosageIdSP
                                                            ON MIString_DosageIdSP.MovementItemId = MovementItem.Id
                                                           AND MIString_DosageIdSP.DescId = zc_MIString_DosageIdSP()

                          WHERE Movement.DescId = zc_Movement_GoodsSP()
                            AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                         )

    SELECT DISTINCT
           _tmpMedication_ID.MedicationID
         , Object_Goods.Id
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData
    FROM _tmpMedication_ID
    
        LEFT JOIN tmpGoodsSP ON tmpGoodsSP.IdSP = _tmpMedication_ID.MedicationID
        
        LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsSP.GoodsId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 18.05.21                                                                                                    * 
*/

-- тест


select * from gpSelect_GoodsSPReceiptList(inMedicalProgramSPId := 18078194 , inMedication_ID_List := '6aff2491-9052-40e2-9412-c1b57156efcc,6aff2491-9052-40e2-9412-c1b57156efcc' ,  inSession := '3');
