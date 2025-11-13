ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION';

SELECT 
    snowflake.cortex.complete(
        'mistral-large',
        'What are large language models'
    );

SELECT
    review,
    snowflake.cortex.complete(
        'mistral-large',
        CONCAT(
            'Critique this review in bullet points: <review>',
            review,
            '</review>'
            )
    )
FROM 
    test.public.imdb_train
LIMIT
    10;


SELECT 
    review,
    snowflake.cortex.complete(
        'mistral-large', 
        [
            {
                'role':'system',
                'content':'Critique this review in bullet points:'
            },
            {
                'role':'user',
                'content':CONCAT('Review the movie: ', review)
            }
        ],
        {
            'temperature':0.7,
            'max_tokens':10
        }  
    ):choices AS moview
FROM 
    test.public.imdb_train
LIMIT
    10;


