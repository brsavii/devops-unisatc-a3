import { test, expect } from "@playwright/test";

test("Deve criar uma nova categoria no Strapi", async ({ page }) => {
  
  await page.goto("http://localhost:1337/admin/auth/login");
  await page.getByLabel("Email").fill("admin@satc.edu.br");
  await page.getByLabel("Password").fill("welcomeToStrapi123");
  await page.getByRole("button", { name: "Login" }).click();

  await page.getByRole("link", { name: "Content Manager" }).click();
  await page.getByRole("link", { name: "Categoria" }).click();
  
  await page.getByRole('main').getByRole('link', { name: 'Create new entry' }).first().click();
  await page.getByLabel("Nome").fill("Teste de Categoria");
  await page.getByRole("button", { name: "Save" }).click();

  await expect(page.getByText('Teste de Categoria')).toBeVisible();
  
  await page.getByRole("button", { name: /SA Super Admin/ }).click();
  await page.getByText("Log out").click();
  await expect(page).toHaveURL(/\/admin\/auth\/login/);
  await page.getByRole("heading", { name: "Welcome to Strapi!" }).click();
});
