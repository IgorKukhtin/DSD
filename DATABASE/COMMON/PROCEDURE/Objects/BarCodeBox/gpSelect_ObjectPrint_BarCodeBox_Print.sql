-- Function: gpSelect_ObjectPrint_BarCodeBox_Print (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ObjectPrint_BarCodeBox_Print (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ObjectPrint_BarCodeBox_Print(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (BarCode TVarChar, AmountPrint TFloat
              ) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);
   
   RETURN QUERY
   WITH 
         tmpPrint AS (SELECT *
                      FROM ObjectPrint
                      WHERE ObjectPrint.UserId = vbUserId
                      )

       , tmpList AS (SELECT tmp.Amount, GENERATE_SERIES (1, tmp.Amount :: Integer) AS Ord
                    FROM (SELECT DISTINCT ObjectFloat.ValueData AS Amount
                          FROM ObjectFloat
                          WHERE ObjectFloat.DescId = zc_ObjectFloat_BarCodeBox_Print()
                          ) AS tmp
                   )

       SELECT Object_BarCodeBox.ValueData     AS BarCode
            , 1 :: TFloat AS AmountPrint
 
       FROM tmpPrint
            LEFT JOIN Object AS Object_BarCodeBox
                             ON Object_BarCodeBox.Id = tmpPrint.ObjectId
                            AND Object_BarCodeBox.DescId = zc_Object_BarCodeBox()
                            AND Object_BarCodeBox.isErased = FALSE
                                 

            INNER JOIN ObjectFloat AS ObjectFloat_Print
                                   ON ObjectFloat_Print.ObjectId = Object_BarCodeBox.Id
                                  AND ObjectFloat_Print.DescId = zc_ObjectFloat_BarCodeBox_Print()
                                  AND COALESCE (ObjectFloat_Print.ValueData,0) <> 0

            LEFT JOIN tmpList ON tmpList.Amount = ObjectFloat_Print.ValueData
       ORDER BY Object_BarCodeBox.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.05.20         *
*/

-- ����
--SELECT * FROM gpSelect_ObjectPrint_BarCodeBox_Print ('2')