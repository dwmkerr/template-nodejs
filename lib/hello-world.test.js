const helloWorld = require('./hello-world');

describe('Hello World', () => {
  test('it can greet correctly', () => {
    const expected = 'Hello World!';
    const result = helloWorld();
    expect(result).toEqual(expected);
  });
});
