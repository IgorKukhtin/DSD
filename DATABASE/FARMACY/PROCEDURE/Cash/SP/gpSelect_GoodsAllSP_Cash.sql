 -- Function: gpSelect_GoodsAllSP_Cash()

--DROP FUNCTION IF EXISTS gpSelect_GoodsSP_Cash (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_GoodsAllSP_Cash (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsAllSP_Cash(
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer
             
             , MedicalProgramIdSP  TVarChar   
             , IdSP                TVarChar
             , ProgramIdSP         TVarChar

             , ColSP         TFloat
             , CountSP       TFloat
             , CountSPMin    TFloat
             , PriceOptSP    TFloat
             , PriceRetSP    TFloat
             , DailyNormSP   TFloat
             , DailyCompensationSP  TFloat
             , PriceSP       TFloat
             , PaymentSP     TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_GoodsSP());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());
    
    RETURN QUERY
    WITH -- Товары соц-проект
           tmpMovement AS (SELECT Movement.Id
                                , Movement.OperDate
                                , MLO_MedicalProgramSP.ObjectId    AS MedicalProgramSPID
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

                           WHERE Movement.DescId = zc_Movement_GoodsSP()
                             AND Movement.StatusId IN (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
                          ),
           tmpMovementItem AS (SELECT MovementItem.Id
                                    , Object_Goods_Retail.Id                                     AS GoodsId

                                    , COALESCE (ObjectString_ProgramId.ValueData, '')::TVarChar  AS MedicalProgramIdSP
                                    , COALESCE (MIString_IdSP.ValueData, '')::TVarChar           AS IdSP
                                    , COALESCE (MIString_ProgramIdSP.ValueData, '')::TVarChar    AS ProgramIdSP

                                    , ROW_NUMBER() OVER (PARTITION BY  COALESCE (ObjectString_ProgramId.ValueData, '')
                                                      , COALESCE (MIString_IdSP.ValueData, '')
                                                      , COALESCE (MIString_ProgramIdSP.ValueData, '') ORDER BY Movement.OperDate DESC) AS Ord
                               FROM tmpMovement AS Movement

                                    INNER JOIN MovementItem ON MovementItem.DescId = zc_MI_Master()
                                                           AND MovementItem.MovementId = Movement.ID
                                                           AND MovementItem.isErased = FALSE
                                                          
                                    LEFT JOIN ObjectString AS ObjectString_ProgramId 	
                                                           ON ObjectString_ProgramId.ObjectId = Movement.MedicalProgramSPID
                                                          AND ObjectString_ProgramId.DescId = zc_ObjectString_MedicalProgramSP_ProgramId()

                                    LEFT JOIN MovementItemString AS MIString_IdSP
                                                                 ON MIString_IdSP.MovementItemId = MovementItem.Id
                                                                AND MIString_IdSP.DescId = zc_MIString_IdSP()

                                    LEFT JOIN MovementItemString AS MIString_ProgramIdSP
                                                                 ON MIString_ProgramIdSP.MovementItemId = MovementItem.Id
                                                                AND MIString_ProgramIdSP.DescId = zc_MIString_ProgramIdSP()

                                    LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId = MovementItem.ObjectId
                                                                                        AND Object_Goods_Retail.RetailId = vbRetailId
                               )

        SELECT MovementItem.Id                                       AS Id
             , MovementItem.GoodsId                                  AS GoodsId
             
             , MovementItem.MedicalProgramIdSP                       AS MedicalProgramIdSP
             , MovementItem.IdSP                                     AS IdSP
             , MovementItem.ProgramIdSP                              AS ProgramIdSP
             
             , MIFloat_ColSP.ValueData                               AS ColSP
             , MIFloat_CountSP.ValueData                             AS CountSP
             , MIFloat_CountSPMin.ValueData                          AS CountSPMin
             , MIFloat_PriceOptSP.ValueData                          AS PriceOptSP
             , MIFloat_PriceRetSP.ValueData                          AS PriceRetSP
             , MIFloat_DailyNormSP.ValueData                         AS DailyNormSP
             , MIFloat_DailyCompensationSP.ValueData                 AS DailyCompensationSP
             , MIFloat_PriceSP.ValueData                             AS PriceSP
             , MIFloat_PaymentSP.ValueData                           AS PaymentSP

        FROM tmpMovementItem AS MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_ColSP
                                        ON MIFloat_ColSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_ColSP.DescId = zc_MIFloat_ColSP()
            LEFT JOIN MovementItemFloat AS MIFloat_CountSP
                                        ON MIFloat_CountSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSP.DescId = zc_MIFloat_CountSP()
            LEFT JOIN MovementItemFloat AS MIFloat_CountSPMin
                                        ON MIFloat_CountSPMin.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountSPMin.DescId = zc_MIFloat_CountSPMin()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceOptSP
                                        ON MIFloat_PriceOptSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceOptSP.DescId = zc_MIFloat_PriceOptSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceRetSP
                                        ON MIFloat_PriceRetSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceRetSP.DescId = zc_MIFloat_PriceRetSP()
            LEFT JOIN MovementItemFloat AS MIFloat_DailyNormSP
                                        ON MIFloat_DailyNormSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyNormSP.DescId = zc_MIFloat_DailyNormSP()
            LEFT JOIN MovementItemFloat AS MIFloat_DailyCompensationSP
                                        ON MIFloat_DailyCompensationSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_DailyCompensationSP.DescId = zc_MIFloat_DailyCompensationSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PriceSP
                                        ON MIFloat_PriceSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PriceSP.DescId = zc_MIFloat_PriceSP()
            LEFT JOIN MovementItemFloat AS MIFloat_PaymentSP
                                        ON MIFloat_PaymentSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_PaymentSP.DescId = zc_MIFloat_PaymentSP()

         WHERE MovementItem.Ord = 1
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 21.10.20                                                      *
*/

--ТЕСТ
--

SELECT * FROM gpSelect_GoodsAllSP_Cash (inSession:= '3')