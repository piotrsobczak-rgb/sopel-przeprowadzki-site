// Netlify Function: send-email
// Receives form POST (application/x-www-form-urlencoded) and sends an email using SendGrid API.

const SENDGRID_API_KEY = process.env.SENDGRID_API_KEY;
const TO_EMAIL = 'piotr.sobczak@tm-bud.pl';
const FROM_EMAIL = process.env.FROM_EMAIL || 'no-reply@sopelprzeprowadzki.pl';

exports.handler = async function(event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  if (!SENDGRID_API_KEY) {
    return { statusCode: 500, body: 'SendGrid API key not configured. Set SENDGRID_API_KEY in Netlify site environment.' };
  }

  // Parse form-encoded body
  const params = new URLSearchParams(event.body);
  const name = params.get('name') || '---';
  const email = params.get('email') || '---';
  const phone = params.get('phone') || '---';
  const address = params.get('address') || '---';
  const message = params.get('message') || '---';

  const subject = `Nowe zapytanie z formularza: ${name}`;
  const plain = `Nowe zapytanie z formularza kontaktowego:\n\nImię i nazwisko: ${name}\nEmail: ${email}\nTelefon: ${phone}\nAdres (skąd->dokąd): ${address}\n\nWiadomość:\n${message}`;

  const html = `<p>Nowe zapytanie z formularza kontaktowego</p>
    <ul>
      <li><strong>Imię i nazwisko:</strong> ${escapeHtml(name)}</li>
      <li><strong>Email:</strong> ${escapeHtml(email)}</li>
      <li><strong>Telefon:</strong> ${escapeHtml(phone)}</li>
      <li><strong>Adres (skąd → dokąd):</strong> ${escapeHtml(address)}</li>
    </ul>
    <h3>Wiadomość</h3>
    <p>${escapeHtml(message).replace(/\n/g,'<br/>')}</p>`;

  // Send via SendGrid API
  const payload = {
    personalizations: [{ to: [{ email: TO_EMAIL }] }],
    from: { email: FROM_EMAIL },
    subject: subject,
    content: [
      { type: 'text/plain', value: plain },
      { type: 'text/html', value: html }
    ]
  };

  try {
    const res = await fetch('https://api.sendgrid.com/v3/mail/send', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer ' + SENDGRID_API_KEY,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const text = await res.text();
      console.error('SendGrid error:', res.status, text);
      return { statusCode: 502, body: `SendGrid error: ${res.status}` };
    }

    // Redirect to thank-you page
    return { statusCode: 302, headers: { Location: '/thank-you.html' }, body: '' };
  } catch (err) {
    console.error('Error sending email', err);
    return { statusCode: 500, body: 'Error sending email' };
  }
};

function escapeHtml(str){
  return String(str)
    .replace(/&/g,'&amp;')
    .replace(/</g,'&lt;')
    .replace(/>/g,'&gt;')
    .replace(/"/g,'&quot;')
    .replace(/'/g,'&#039;');
}
