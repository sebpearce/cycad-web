import express from 'express';
import { graphiqlExpress } from 'apollo-server-express';

var app = express();

app.use(
  '/graphiql',
  graphiqlExpress({
    endpointURL: 'http://localhost:4567/graphql',
  })
);

app.listen(3131, () => console.log('Example app listening on port 3131!'));
