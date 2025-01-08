const got = require('got');
const FormData = require('form-data');

const apiKey = 'acc_4cd9dcfca36cc39';
const apiSecret = '9c67c2f48bf6d4d5a304cb353c9a36f9';
const url = 'https://api.imagga.com/v2/tags';

function convertToDataUri(base64String) {
  // Remove any prefix
  return base64String.replace(/^data:image\/[a-z]+;base64,/, '');
}

module.exports = async function generateTags(base64Image) {
  const formattedBase64 = convertToDataUri(base64Image);

  if (!formattedBase64) {
    throw new Error("Base64 string is empty!");
  }

  const form = new FormData();
  form.append('image_base64', formattedBase64);  // Use the raw Base64 image

  try {
    const response = await got.post(url, {
      headers: {
        'Authorization': `Basic ${Buffer.from(`${apiKey}:${apiSecret}`).toString('base64')}`,
        ...form.getHeaders(),
      },
      body: form,
      responseType: 'json',
    });

    const tags = response.body.result.tags.map(tag => tag.tag.en);
    console.log("Tags:", tags);
    return tags;
  } catch (error) {
    console.error("Error:", error.response?.body || error.message);
    throw error;
  }
};