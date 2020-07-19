-- Function: gpSelect_Replica_Column()

DROP FUNCTION IF EXISTS _replica.gpSelect_Replica_Column (Integer, Integer);

CREATE OR REPLACE FUNCTION _replica.gpSelect_Replica_Column(
    IN inId_start     Integer,
    IN inId_end       Integer
)
RETURNS TABLE (TABLE_NAME Text, COLUMN_NAME Text, COLUMN_NAME_full Text
) AS
$BODY$
BEGIN

   RETURN QUERY 
    SELECT tmp.TABLE_NAME :: Text
         , STRING_AGG (tmp.COLUMN_NAME , ',''||''' ORDER BY COLUMN_POSITION)    :: Text                   AS COLUMN_NAME
         , STRING_AGG ( 'CASE WHEN CAST (' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || ' AS Text) IS NULL'
                        || ' THEN ' || _replica.zfStr_CHR_39 ('NULL')
                        || ' ELSE CAST (' || CASE WHEN tmp.COLUMN_TYPENAME ILIKE 'TVarChar'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'TDateTime'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'Text'
                                                    OR tmp.COLUMN_TYPENAME ILIKE 'TBlob'
                                               THEN _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l') || '||' || tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME || '||' || _replica.zfStr_CHR_39 ('n/e/ /p/r/i/d/u/m/a/l')
                                             ELSE tmp.TABLE_NAME ||'.'||tmp.COLUMN_NAME
                                             END || '  AS Text)'
                        || ' END' , '||'',''||' ORDER BY COLUMN_POSITION)  :: Text AS  COLUMN_NAME_full

    FROM (SELECT * FROM _replica.gpSelect_Replica_Table (inId_start, inId_end)) AS tmp
    GROUP BY tmp.TABLE_NAME
    ORDER BY 1;
     
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.20          *
*/

-- ����
--
-- SELECT * FROM _replica.gpSelect_Replica_Column(1, 657179)
