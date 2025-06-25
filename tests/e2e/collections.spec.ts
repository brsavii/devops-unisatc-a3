import { test, expect } from '@playwright/test';

const BASE = 'http://localhost:1337';

test.describe('Collections Strapi', () => {
  test('CRUD Categoria', async ({ request }) => {
    // Autentica como super-admin
    const { body: login } = await request.post(`${BASE}/api/auth/local`, {
      data: { identifier: 'admin@satc.edu.br', password: 'welcomeToStrapi123' }
    });
    const token = login.jwt;

    // Cria categoria
    const { status: statusCreate, body: created } = await request.post(`${BASE}/api/categories`, {
      headers: { Authorization: `Bearer ${token}` },
      data: { name: 'TesteCat' }
    });
    expect(statusCreate).toBe(200);
    expect(created.data.attributes.name).toBe('TesteCat');

    // Deleta categoria
    const { status: statusDel } = await request.delete(`${BASE}/api/categories/${created.data.id}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    expect(statusDel).toBe(200);
  });

  test('Listagem de Articles', async ({ request }) => {
    const { status, body } = await request.get(`${BASE}/api/articles`);
    expect(status).toBe(200);
    expect(Array.isArray(body.data)).toBeTruthy();
  });
});
