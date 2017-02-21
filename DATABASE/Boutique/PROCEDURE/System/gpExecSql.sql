DROP FUNCTION IF EXISTS gpExecSql(tvarchar, TVarChar);

CREATE OR REPLACE FUNCTION gpExecSql(IN SqlText tvarchar, IN Session TVarChar) 
RETURNS TABLE(test INTEGER, true1 boolean, false1 boolean--, TVarChar1 TVarChar, Date1 TDateTime, float1 TFloat, text1 TBlob
) AS $BODY$
begin
  RETURN QUERY SELECT 1 AS test, TRUE AS true1, false AS false1;--, 'жаба'::TVarChar AS TVarChar1, 
  --CURRENT_DATE::TDateTime AS Date1, 12.567::TFloat AS float1, 'трактор'::TBlob AS text1;--SqlText;
END;
$BODY$LANGUAGE plpgsql;



-- SELECT * FROM gpExecSql('SELECT 1 AS test', '')