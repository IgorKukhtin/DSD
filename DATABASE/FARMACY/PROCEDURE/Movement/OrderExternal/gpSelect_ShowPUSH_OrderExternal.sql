-- Function: gpSelect_ShowPUSH_OrderExternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_OrderExternal(integer,integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_OrderExternal(
    IN inSupplierID   integer,          -- Поставщик
    IN inUnitID       integer,          -- Подразделение
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbName  TVarChar;
   DECLARE vbJuridical Integer;

   DECLARE vbX  TFloat;
   DECLARE vbY  TFloat;
   DECLARE vbN  TFloat;
BEGIN

    outShowMessage := False;

    IF inSession in (zfCalc_UserAdmin(), '3004360', '4183126', '3171185')  AND
      EXISTS(SELECT 1 FROM  ObjectFloat AS ObjectFloat_CreditLimit
             WHERE ObjectFloat_CreditLimit.ObjectId = inSupplierID
               AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_Juridical_CreditLimit())
    THEN

      -- Получаем N
      SELECT Object_Juridical.ValueData          AS Name
           , ObjectFloat_CreditLimit.ValueData   AS CreditLimit
      INTO vbName
         , vbN
      FROM Object AS Object_Juridical

           JOIN ObjectFloat AS ObjectFloat_CreditLimit
                            ON ObjectFloat_CreditLimit.ObjectId = Object_Juridical.Id
                           AND ObjectFloat_CreditLimit.DescId = zc_ObjectFloat_Juridical_CreditLimit()

      WHERE Object_Juridical.Id = inSupplierID;

      IF COALESCE(vbN, 0) = 0
      THEN
        RETURN;
      END IF;

      vbJuridical := (SELECT ObjectLink_Unit_Juridical.ChildObjectId AS RetailId
                     FROM ObjectLink AS ObjectLink_Unit_Juridical
                     WHERE ObjectLink_Unit_Juridical.ObjectId = inUnitID
                       AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

      SELECT SUM(MovementFloat_TotalSumm.ValueData)
      INTO vbX
      FROM Movement AS Movement_Income
           LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

           LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                        ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           LEFT JOIN MovementDate AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId =  Movement_Income.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

           -- Партия накладной
           LEFT JOIN Object AS Object_Movement
                            ON Object_Movement.ObjectCode = Movement_Income.Id
                           AND Object_Movement.DescId = zc_Object_PartionMovement()

           LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                              AND Container.ObjectId = Object_Movement.Id
                              AND Container.KeyValue like '%,'||MovementLinkObject_Juridical.ObjectId||';%'

      WHERE CASE WHEN Container.Amount > 0.01 OR Movement_Income.StatusId <> zc_Enum_Status_Complete()
            THEN MovementDate_Payment.ValueData END Is Not Null
        AND Movement_Income.DescId = zc_Movement_Income()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridical
        AND MovementLinkObject_From.ObjectId = inSupplierID;

      SELECT SUM(MovementFloat_TotalSumm.ValueData)
      INTO vbY
      FROM Movement_Payment_View AS Movement_Payment

          INNER JOIN MovementItem AS MI_Payment
                                  ON MI_Payment.MovementId = Movement_Payment.Id
                                 AND MI_Payment.DescId     = zc_MI_Master()
                                 AND MI_Payment.isErased = FALSE

          LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                            ON MIFloat_IncomeId.MovementItemId = MI_Payment.ID
                                           AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
          LEFT OUTER JOIN Movement AS Movement_Income ON Movement_Income.Id = MIFloat_IncomeId.ValueData :: Integer
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                       ON MovementLinkObject_Juridical.MovementId = Movement_Income.Id
                                      AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()

          LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                             ON MLO_From.MovementId = Movement_Income.Id
                                            AND MLO_From.DescId = zc_MovementLinkObject_From()
          LEFT OUTER JOIN Object AS Object_From ON Object_From.Id = MLO_From.ObjectId

          LEFT OUTER JOIN MovementLinkObject AS MLO_To
                                             ON MLO_To.MovementId = Movement_Income.Id
                                            AND MLO_To.DescId = zc_MovementLinkObject_To()
          LEFT OUTER JOIN Object AS Object_To ON Object_To.Id = MLO_To.ObjectId

          LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                  ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                                 AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

      WHERE Movement_Payment.StatusId = zc_Enum_Status_UnComplete()
        AND MovementLinkObject_Juridical.ObjectId = vbJuridical
        AND MLO_From.ObjectId = inSupplierID;

      outShowMessage := True;
      outPUSHType := 3;
      outText := 'Лимит по контрагенту:'||CHR(13)||'<'||vbName||'>'||CHR(13)||CHR(13)||
        'Кредит (Приход) X: '||to_char(COALESCE(vbX, 0), 'G999G999G999G999D99')||' с НДС'||CHR(13)||
        'Дебет (Оплата)  Y: '||to_char(COALESCE(vbY, 0), 'G999G999G999G999D99')||' с НДС'||CHR(13)||
        'Лимит           N: '||to_char(vbN, 'G999G999G999G999D99')||' с НДС'||CHR(13)||CHR(13)||
        'Лимит     N-(X-Y): '||to_char(vbN - COALESCE(vbX, 0) + COALESCE(vbY, 0), 'G999G999G999G999D99')||' с НДС';
    END IF;


END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.05.19                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_OrderExternal(59610,0,'3')