// tests/Feature/TaskTest.php
namespace Tests\Feature;

use Tests\TestCase;

class TaskTest extends TestCase
{
    /**
     * Test the index method of TaskController.
     *
     * @return void
     */
    public function testIndexMethod()
    {
        $response = $this->get('/api/tasks');

        $response->assertStatus(200);
        $response->assertJsonStructure([
            '*' => [
                'id', 'name', 'description', // ここに期待するJSON構造を記述
            ]
        ]);
    }
}