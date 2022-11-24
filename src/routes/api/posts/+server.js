// import { SECRET_API_KEY } from "$env/static/private"

export const GET = async ({ request, url }) => {
    // const authHeader = request.headers.get('Authorization')

    // if (authHeader != "MyAthHeader") {
    //     return new Response(JSON.stringify({message: "invalid credentials"}), {status: 401})
    // }

    const limit = Number(url.searchParams.get("limit") ?? '10')
    const skip = Number(url.searchParams.get("skip") ?? '0')

    const res = await fetch(`https://dummyjson.com/posts?limit=${limit}&skip=${skip}`)
    const data = await res.json()

    return new Response(JSON.stringify(data), {status: 200})
}

export const POST = async ({ request }) => {
    const body = await request.json()
    const authHeader = request.headers.get('Authorization')

    if (authHeader != "MyAthHeader") {
        return new Response(JSON.stringify({message: "invalid credentials"}), {status: 401})
    }

    console.log(body);

    return new Response(JSON.stringify({message: "Success"}), {status: 201})
}